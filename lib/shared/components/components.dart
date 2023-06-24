import 'package:flutter/material.dart';
import 'package:to_do/shared/cubit/cubit.dart';

Widget buildTaskItem(Map model, context) =>   Dismissible(
    key: Key(model['id'].toString()),
    child: Padding(
  padding: const EdgeInsetsDirectional.only(
      start: 15.0, end: 15.0, top: 5.0, bottom: 5.0),
  child: Row(
    children: [
      CircleAvatar(
        radius: 40.0,
        child: Text(
          '${model['time']}',
        ),
      ),
      const SizedBox(
        width: 10,
      ),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${model['title']}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              '${model['date']}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 20,
              ),
            ),
          ],
        ),),
      const SizedBox(
        width: 15,
      ),
      IconButton(
        onPressed: (){
          AppCubit.get(context).updateDB(status: 'done', id: model['id']);
        },
        icon: const Icon(
          Icons.check_box,
          color: Colors.green,
        ),
      ),
      IconButton(
        onPressed: (){
          AppCubit.get(context).updateDB(status: 'archive', id: model['id']);
        },
        icon: const Icon(Icons.archive,
        ),
      ),
    ],
  ),
),
  onDismissed: (dirction){
      AppCubit.get(context).deleteDB(id: (model['id']));
  },
);

