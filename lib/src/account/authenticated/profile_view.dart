import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:windowshoppi/src/utilities/expandable_text.dart';

class ProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: BlocBuilder<AuthenticationBloc, AuthenticationStates>(
        builder: (context, state) {
          if (state is IsAuthenticated) {
            var data = state.user;
            return ListView(
              children: [
                Row(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 30.0,
                      backgroundColor: Colors.grey[300],
                      child: Icon(Icons.store, size: 28, color: Colors.grey),
                    ),
                    Expanded(
                      child: data.userBusiness[0].location != null
                          ? ListTile(
                              title: Text('${data.userBusiness[0].name}'),
                              subtitle:
                                  Text('${data.userBusiness[0].location}'),
                              trailing: Column(
                                children: <Widget>[
                                  Text(
                                    '12',
                                    style: TextStyle(
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 4.0),
                                    child: Text(
                                      'POSTS',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListTile(
                              title: Text('${data.userBusiness[0].name}'),
                              trailing: Column(
                                children: <Widget>[
                                  Text(
                                    '12',
                                    style: TextStyle(
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 4.0),
                                    child: Text(
                                      'POSTS',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(3.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Row(
                          children: <Widget>[
                            CircleAvatar(
                              backgroundColor: Colors.blue,
                              radius: 15.0,
                              child: FaIcon(
                                FontAwesomeIcons.phone,
                                size: 15.0,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              width: 8.0,
                            ),
                            Expanded(
                              child: Text(
                                '${data.phoneNumber[0].callNumber}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: <Widget>[
                            CircleAvatar(
                              backgroundColor: Color(0xFF06B862),
                              radius: 15.0,
                              child: FaIcon(
                                FontAwesomeIcons.whatsapp,
                                size: 15.0,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              width: 8.0,
                            ),
                            Expanded(
                              child: data.phoneNumber[0].whatsappNumber != null
                                  ? Text(
                                      '${data.phoneNumber[0].whatsappNumber}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )
                                  : Text(
                                      'not specified',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (data.email != null)
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Text(
                      '${data.email}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                if (data.userBusiness[0].bio != null)
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ExpandableText(
                      text: '${data.userBusiness[0].bio}',
                      trimLines: 1,
                      readLess: true,
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: OutlineButton(
                    padding: EdgeInsets.zero,
                    splashColor: Colors.red,
                    onPressed: () {},
                    child: Text('UPDATE PROFILE'),
                  ),
                )
              ],
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
