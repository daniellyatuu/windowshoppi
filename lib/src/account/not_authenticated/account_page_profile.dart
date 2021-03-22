import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:windowshoppi/src/utilities/action.dart';
import 'package:windowshoppi/src/utilities/expandable_text.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:windowshoppi/src/widget/widget_files.dart';

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
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width / 4,
                    height: MediaQuery.of(context).size.width / 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      shape: BoxShape.circle,
                    ),
                    child: data.accountProfile == null
                        ? FittedBox(
                            child: Icon(
                              Icons.account_circle,
                              color: Colors.white,
                            ),
                          )
                        : ClipOval(
                            child: ExtendedImage.network(
                              '${data.accountProfile}',
                              cache: true,
                              loadStateChanged: (ExtendedImageState state) {
                                switch (state.extendedImageLoadState) {
                                  case LoadState.loading:
                                    return CupertinoActivityIndicator();
                                    break;

                                  ///if you don't want override completed widget
                                  ///please return null or state.completedWidget
                                  //return null;
                                  //return state.completedWidget;
                                  case LoadState.completed:
                                    return ExtendedRawImage(
                                      fit: BoxFit.cover,
                                      image: state.extendedImageInfo?.image,
                                    );
                                    break;
                                  case LoadState.failed:
                                    // _controller.reset();
                                    return GestureDetector(
                                      child: FittedBox(
                                        child: Icon(
                                          Icons.account_circle,
                                          color: Colors.white,
                                        ),
                                      ),
                                      onTap: () {
                                        state.reLoadImage();
                                      },
                                    );
                                    break;
                                }
                                return null;
                              },
                            ),
                          ),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Container(
                //     width: 120,
                //     height: 120,
                //     decoration: BoxDecoration(
                //       color: Colors.grey[200],
                //       shape: BoxShape.circle,
                //     ),
                //     child: data.accountProfile == null
                //         ? FittedBox(
                //             child: Icon(Icons.account_circle,
                //                 color: Colors.grey[400]),
                //           )
                //         : CircleAvatar(
                //             backgroundColor: Colors.grey[200],
                //             radius: 60.0,
                //             backgroundImage:
                //                 NetworkImage('${data.accountProfile}'),
                //           ),
                //   ),
                // ),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AccountInfo(
                      name: 'Followers',
                      number: 12,
                    ),
                    AccountInfo(
                      name: 'Following',
                      number: 15,
                    ),
                    AccountInfo(
                      name: 'Posts',
                      number: 30,
                    ),
                  ],
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
                                call(data.callDialCode + data.call);
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
                                  chat(data.whatsappDialCode + data.whatsapp,
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
