import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do/shared/cubit/cubit.dart';

import '../../shared/components/components.dart';
import '../../shared/cubit/states.dart';

class NewTasks extends StatelessWidget {
  const NewTasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        
      },
      builder: (context, state) {
        var tasks=AppCubit.get(context).newTasks;
        if (tasks.isEmpty){
          return const Center(
            child: Text(
              'New Tasks',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }
        return ListView.separated(
            itemBuilder: (context, index) => buildTaskItem(tasks[index], context),
            separatorBuilder: (context, index) =>
                Container(
                  width: double.infinity,
                  height: 1.0,
                  color: Colors.grey[300],
                ),
            itemCount: tasks.length
        );
      },
    );
  }
}

