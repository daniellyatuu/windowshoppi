import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:windowshoppi/src/model/model_files.dart';

class InfoList extends StatelessWidget {
  final List<NotificationModel> data;
  const InfoList({Key key, @required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationBloc, NotificationStates>(
      builder: (context, state) {
        return ListView.builder(
          key: PageStorageKey<String>('notifications'),
          physics: BouncingScrollPhysics(),
          itemCount: data.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            NotificationModel notification = data[index];
            return ListTile(
              onTap: () {
                // print('here please');
              },
              title: Text(
                '${notification.content}',
                textAlign: TextAlign.justify,
              ),
            );
          },
        );
      },
    );
  }
}
