import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/components/components.dart';
import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/states.dart';

class DoneTasks extends StatelessWidget {
  const DoneTasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {

      },
      builder: (context, state) {
        var tasks=AppCubit.get(context).doneTasks;
        if (tasks.isEmpty){
          return const Center(
            child: Text(
              'Done Tasks',
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
