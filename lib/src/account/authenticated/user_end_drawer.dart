import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:windowshoppi/src/account/account_files.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';

class UserEndDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Container(
              child: ConstrainedBox(
                constraints: constraints.copyWith(
                  minHeight: constraints.maxHeight,
                  maxHeight: double.infinity,
                ),
                child: IntrinsicHeight(
                  child: SafeArea(
                    child: Column(
                      children: [
                        Column(
                          children: <Widget>[
                            ListTile(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Settings(),
                                  ),
                                );
                              },
                              leading: Icon(Icons.settings),
                              dense: true,
                              title: Text('Settings'),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Divider(),
                                ListTile(
                                  onTap: () {
                                    // delete user token
                                    BlocProvider.of<AuthenticationBloc>(context)
                                        .add(UserLoggedOut());

                                    // rebuild the app
                                    Phoenix.rebirth(context);

                                    // // open account page
                                    // BlocProvider.of<NavigationBloc>(context)
                                    //   ..add(ChangeIndex(index: 4));
                                  },
                                  dense: true,
                                  leading: Icon(Icons.logout),
                                  title: Text('LOGOUT'),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
    // return Drawer(
    //   child: ListView(
    //     children: <Widget>[
    //       GestureDetector(
    //         onTap: () {
    //           BlocProvider.of<AuthenticationBloc>(context).add(UserLoggedOut());
    //         },
    //         child: Card(
    //           child: ListTile(
    //             dense: true,
    //             title: Text('LOGOUT'),
    //           ),
    //         ),
    //       )
    //     ],
    //   ),
    // );
  }
}
