import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:windowshoppi/main.dart';
import 'package:windowshoppi/push_notification.dart';
import 'package:windowshoppi/src/widget/widget_files.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windowshoppi/app_root.dart';
import 'package:flutter/material.dart';

class AppInitRoot extends StatefulWidget {
  const AppInitRoot({Key key}) : super(key: key);

  @override
  _AppInitRootState createState() => _AppInitRootState();
}

class _AppInitRootState extends State<AppInitRoot> {
  /// FIREBASE NOTIFICATION .START
  String token;

  @override
  void initState() {
    super.initState();
    var initialzationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initialzationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        BlocProvider.of<NotificationBloc>(context)..add(NotificationRefresh());
        if (notification.title != 'unfollow') {
          flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                icon: android?.smallIcon,
              ),
            ),
          );
        }
      }
    });
    getToken();
    // getTopics();
  }

  getToken() async {
    token = await FirebaseMessaging.instance.getToken();

    print('TOKEN ==== $token');
  }

  // getTopics() async {
  //   await FirebaseFirestore.instance
  //       .collection('topics')
  //       .get()
  //       .then((value) => value.docs.forEach((element) {
  //             if (token == element.id) {
  //               subscribed = element.data().keys.toList();
  //             }
  //           }));
  //
  //   setState(() {
  //     subscribed = subscribed;
  //   });
  // }

  /// FIREBASE NOTIFICATION .END

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationBloc, AuthenticationStates>(
      listener: (context, state) {
        if (state is IsAuthenticated) {
          // Fetch All Account Post
          BlocProvider.of<AuthPostBloc>(context)
            ..add(AuthPostInitFetch(accountId: state.user.accountId));

          // Fetch My Post
          BlocProvider.of<UserPostBloc>(context)
            ..add(UserPostFetchedInit(accountId: state.user.accountId));

          //  Fetch Account Follower No, Following No And Post No
          BlocProvider.of<AccountInfoBloc>(context)
            ..add(GetAccountInfo(accountId: state.user.accountId));

          // Fetch Account List
          BlocProvider.of<AccountListBloc>(context)
            ..add(AccountInitFetch(activeAccountId: state.user.accountId));

          // Fetch Following Post
          BlocProvider.of<FollowingPostBloc>(context)
            ..add(FollowingPostInitFetch(accountId: state.user.accountId));

          // Fetch Notification
          BlocProvider.of<NotificationBloc>(context)
            ..add(NotificationInitFetch(accountId: state.user.accountId));

          if (token != null) {
            BlocProvider.of<FcmTokenBloc>(context)
              ..add(UpdateToken(fcmToken: token));
          }
        } else if (state is IsNotAuthenticated) {
          // Fetch All Account Post
          BlocProvider.of<AllPostBloc>(context)..add(AllPostFetched());

          // Fetch Account List
          BlocProvider.of<AccountListBloc>(context)..add(AccountInitFetch());
        }
      },
      builder: (context, state) {
        if (state is AuthenticationLoading) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Windowshoppi'),
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is AuthNoInternet) {
          return GestureDetector(
            onTap: () {
              BlocProvider.of<AuthenticationBloc>(context)
                  .add(CheckUserLoggedInStatus());
            },
            child: Scaffold(
              appBar: AppBar(
                title: Text('Windowshoppi'),
              ),
              body: Container(
                width: MediaQuery.of(context).size.width,
                child: NoInternet(),
              ),
            ),
          );
        } else if (state is IsAuthenticated || state is IsNotAuthenticated) {
          return AppRoot();
        } else {
          return Container();
        }
      },
    );
  }
}
