import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do/shared/cubit/states.dart';

import '../../modules/archived_tasks/archived_tasks.dart';
import '../../modules/done_tasks/done_tasks.dart';
import '../../modules/new_tasks/new_tasks.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitState());
  static AppCubit get(context) => BlocProvider.of(context);

  Database? database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  IconData fabIcon = Icons.add;
  bool bottomSheet = false;
  int currentIndex = 0;
  List<Widget> screens = [
    const NewTasks(),
    const DoneTasks(),
    const ArchivedTask(),
  ];
  List<String> screenTitle = ['New Tasks', 'Done Tasks', 'Archived Tasks'];

  void changeNavBar(int index) {
    currentIndex = index;
    emit(AppChangeNavBarButtonState());
  }

  void changeFabIcon({required bool isShow, required IconData icone}) {
    bottomSheet = isShow;
    fabIcon = icone;
    emit(AppChangeFabIconeState());
  }

  void creatDB() {
    openDatabase('todo.db', version: 1,
        onCreate: (Database database, int version)
        {
      database.execute
        (
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, time TEXT, date TEXT, status TEXT)'
      ).then((value)
      {
        print('table created');
      }).catchError((error)
      {
        print('Error When Creating Database ${error.toString()}');
      });
    },
        onOpen: (database)
        {
        getFromDB(database);
        print('Database Opened');
       }).then((value)
      {
        database = value;
       emit(AppCreatDBState());
      });
  }

  Future insertDB({
    @required String? title,
    @required String? time,
    @required String? date,
  }) async {
    return await database?.transaction((txn) async
    {
      txn.rawInsert(
              'INSERT INTO tasks(title, time, date, status) VALUES("$title", "$time", "$date", "new")'
      ).then((value)
      {
        print('$value Inserted Successfuly');
        emit(AppInsertDBState());

        getFromDB(database);

      }).catchError((error)
      {
        print('Error When Inssert Database ${error.toString()}');
      });
      return "";
    });
  }

  void getFromDB(database)  {

    newTasks=[];
    doneTasks=[];
    archivedTasks=[];
    emit(AppGetFromDBLoadState());
    database.rawQuery('SELECT * FROM tasks').then((value)
    {
      value.forEach((element)
      {
        if(element['status']== 'new'){
          newTasks.add(element);
        }
        else if(element['status']== 'done'){
          doneTasks.add(element);
        }
        else
          {
            archivedTasks.add(element);
          }
      });

      emit(AppGetFromDBState());
    });;
  }

  void updateDB({
    required String status,
    required int id
  }) async{
    database?.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id],
    ).then((value)
    {
      getFromDB(database);
      emit(AppUpdateDBState());
    });
  }


  void deleteDB({
    required int id
  }) async
  {
    database?.rawDelete('DELETE FROM tasks WHERE id = ?', [id]
    ).then((value)
    {
      getFromDB(database);
      emit(AppdeleteDBState());
    });
  }

}
