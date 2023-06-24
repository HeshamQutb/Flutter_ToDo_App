// ignore_for_file: avoid_print

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

import '../shared/components/constants.dart';
import '../shared/cubit/cubit.dart';
import '../shared/cubit/states.dart';

class HomeLayout extends StatelessWidget {


  var scaffoldkey = GlobalKey<ScaffoldState>();
  var formkey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  HomeLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..creatDB(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {
          if (state is AppInsertDBState){
            Navigator.pop(context);
            titleController.clear();
            timeController.clear();
            dateController.clear();
          }
        },
        builder: (context, state) {
          AppCubit cubit = BlocProvider.of(context);
          return Scaffold(
            key: scaffoldkey,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text(
                cubit.screenTitle[cubit.currentIndex],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: ConditionalBuilder(
                condition: state is! AppGetFromDBLoadState,
                builder: (context) => cubit.screens[cubit.currentIndex],
                fallback: (context) =>
                const Center(child: CircularProgressIndicator(),)
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.bottomSheet) {
                  if (formkey.currentState!.validate()) {
                    cubit.insertDB(title: titleController.text, time: timeController.text, date: dateController.text);
                  }
                }
                else {
                  scaffoldkey.currentState?.showBottomSheet
                    (
                          (context) => Container(
                            color: Colors.white70,
                            padding: const EdgeInsets.all(20.0),
                            child: Form(
                              key: formkey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextFormField(
                                    controller: titleController,
                                    keyboardType: TextInputType.text,
                                    validator: (String? value) {
                                      if (value!.isEmpty) {
                                        return 'Title must not be Empty';
                                      }
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                        labelText: 'Task Title',
                                        prefixIcon: Icon(Icons.title),
                                        border: OutlineInputBorder()),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  TextFormField(
                                    controller: timeController,
                                    keyboardType: TextInputType.text,
                                    validator: (String? value) {
                                      if (value!.isEmpty) {
                                        return 'Time must not be Empty';
                                      }
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                        labelText: 'Task Time',
                                        prefixIcon: Icon(Icons.watch_later),
                                        border: OutlineInputBorder()),
                                    readOnly: true,
                                    onTap: () {
                                      showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                      ).then((value) {
                                        timeController.text =
                                            value!.format(context).toString();
                                      });
                                    },
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  TextFormField(
                                    controller: dateController,
                                    keyboardType: TextInputType.text,
                                    validator: (String? value) {
                                      if (value!.isEmpty) {
                                        return 'Date must not be Empty';
                                      }
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                        labelText: 'Task Date',
                                        prefixIcon: Icon(Icons.calendar_month),
                                        border: OutlineInputBorder()),
                                    readOnly: true,
                                    onTap: () {
                                      showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime.now(),
                                          lastDate: DateTime(2024))
                                          .then((value) {
                                        dateController.text = DateFormat.yMMMd()
                                            .format(value!)
                                            .toString();
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                      elevation: 40.0
                  ).closed.then((value) {
                    cubit.changeFabIcon(isShow: false, icone: Icons.add);
                  });
                  cubit.changeFabIcon(isShow: true, icone: Icons.done);
                }
              },
              child: Icon(
                cubit.fabIcon,
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.currentIndex,
              type: BottomNavigationBarType.fixed,
              onTap: (index)
              {
                cubit.changeNavBar(index);
              },
              items: [
                BottomNavigationBarItem(
                    icon: const Icon(Icons.menu), label: cubit.screenTitle[0]),
                BottomNavigationBarItem(
                    icon: const Icon(Icons.done), label: cubit.screenTitle[1]),
                BottomNavigationBarItem(
                    icon: const Icon(Icons.archive), label: cubit.screenTitle[2]),
              ],
            ),
          );
        },
      ),
    );
  }
}


