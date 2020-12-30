import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:windowshoppi/src/utilities/action.dart';
import 'package:windowshoppi/src/utilities/expandable_text.dart';

class AccountPageProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountDetailBloc, AccountDetailStates>(
      builder: (context, state) {
        if (state is AccountDetailSuccess) {
          var data = state.account;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300], width: 2.0),
                      borderRadius: BorderRadius.circular(8.0),
                      shape: BoxShape.rectangle,
                    ),
                    child: Icon(
                      Icons.account_box,
                      color: Colors.grey[300],
                      size: 70,
                    ),
                  ),
                ),
                Text(
                  '${data.accountName}',
                  style: Theme.of(context).textTheme.headline6,
                ),
                if (data.group == 'vendor')
                  Container(
                    child: Text(
                      ' ${data.businessBio}',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                if (data.group == 'windowshopper')
                  if (data.accountBio != null) Divider(),
                if (data.group == 'vendor')
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: OutlineButton(
                              onPressed: () {
                                call(data.call);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  FaIcon(
                                    FontAwesomeIcons.phone,
                                    size: 15.0,
                                    color: Colors.blue,
                                  ),
                                  Text(
                                    ' CALL',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (data.whatsapp != null)
                            SizedBox(
                              width: 20.0,
                            ),
                          if (data.whatsapp != null)
                            Expanded(
                              child: OutlineButton(
                                onPressed: () {
                                  chat(data.whatsapp,
                                      "Hi there! I have seen your post on windowshoppi");
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    FaIcon(
                                      FontAwesomeIcons.whatsapp,
                                      size: 18.0,
                                      color: Color(0xFF06B862),
                                    ),
                                    Text(
                                      ' CHAT',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Color(0xFF06B862),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                      if (data.email != null)
                        Row(
                          children: [
                            Icon(
                              Icons.email_outlined,
                              size: 16.0,
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                ' ${data.email}',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ),
                          ],
                        ),
                      if (data.accountBio != null)
                        Container(
                          alignment: Alignment.centerLeft,
                          child: ExpandableText(
                            text: '${data.accountBio}',
                            trimLines: 5,
                            readLess: true,
                          ),
                        ),
                    ],
                  ),
                if (data.group == 'windowshopper')
                  Column(
                    children: [
                      if (data.accountBio != null)
                        Container(
                          alignment: Alignment.centerLeft,
                          child: ExpandableText(
                            text: '${data.accountBio}',
                            trimLines: 3,
                            readLess: true,
                          ),
                        ),
                    ],
                  ),
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
