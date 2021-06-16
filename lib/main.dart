import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:windowshoppi/app_init_root.dart';
import 'package:windowshoppi/src/repository/repository_files.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:windowshoppi/welcome_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windowshoppi/app_root.dart';
import 'package:flutter/material.dart';
import 'package:sentry/sentry.dart';
import 'dart:async';
import 'dsn.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
  print(message.data);
  flutterLocalNotificationsPlugin.show(
      message.data.hashCode,
      message.data['title'],
      message.data['body'],
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channel.description,
        ),
      ));
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

final SentryClient _sentry = new SentryClient(dsn: dsn);

bool get isInDebugMode {
  bool inDebugMode = false;
  assert(inDebugMode = true);
  return inDebugMode;
}

/// Reports [error] along with its [stackTrace] to Sentry.io.
Future<Null> _reportError(dynamic error, dynamic stackTrace) async {
  print('Caught error: $error');

  // Errors thrown in development mode are unlikely to be interesting. You can
  // check if you are running in dev mode using an assertion and omit sending
  // the report.
  if (isInDebugMode) {
    print(stackTrace);
    print('In dev mode. Not sending report to Sentry.io.');
    return;
  }

  print('Reporting to Sentry.io...');

  final SentryResponse response = await _sentry.captureException(
    exception: error,
    stackTrace: stackTrace,
  );

  if (response.isSuccessful) {
    print('Success! Event ID: ${response.eventId}');
  } else {
    print('Failed to report to Sentry.io: ${response.error}');
  }
}

Future<Null> main() async {
  // This captures errors reported by the Flutter framework.
  FlutterError.onError = (FlutterErrorDetails details) async {
    if (isInDebugMode) {
      // In development mode simply print to console.
      FlutterError.dumpErrorToConsole(details);
    } else {
      // In production mode report to the application zone to report to
      // Sentry.
      Zone.current.handleUncaughtError(details.exception, details.stack);
    }
  };

  runZonedGuarded<Future<Null>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    runApp(
      Phoenix(child: MyApp()),
    );
  }, (error, stackTrace) async {
    await _reportError(error, stackTrace);
  });
}

class MyApp extends StatelessWidget {
  final AuthenticationRepository authenticationRepository =
      AuthenticationRepository(
    authenticationAPIClient: AuthenticationAPIClient(),
  );

  final UserPostRepository userPostRepository = UserPostRepository(
    userPostAPIClient: UserPostAPIClient(),
  );

  final AllPostRepository allPostRepository = AllPostRepository(
    allPostAPIClient: AllPostAPIClient(),
  );

  final AccountPostRepository accountPostRepository = AccountPostRepository(
    accountPostAPIClient: AccountPostAPIClient(),
  );

  final AuthPostRepository authPostRepository = AuthPostRepository(
    authPostAPIClient: AuthPostAPIClient(),
  );

  final SearchPostRepository searchPostRepository = SearchPostRepository(
    searchPostAPIClient: SearchPostAPIClient(),
  );

  final AuthSearchPostRepository authSearchPostRepository =
      AuthSearchPostRepository(
    authSearchPostAPIClient: AuthSearchPostAPIClient(),
  );

  final SearchAccountRepository searchAccountRepository =
      SearchAccountRepository(
    searchAccountAPIClient: SearchAccountAPIClient(),
  );

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NetworkBloc>(
          create: (context) => NetworkBloc()..add(ListenConnection()),
        ),
        BlocProvider<NavigationBloc>(
          create: (context) => NavigationBloc()..add(ChangeIndex(index: 0)),
        ),
        BlocProvider<UserAppVisitBloc>(
          create: (context) => UserAppVisitBloc()..add(CheckUserAppVisit()),
        ),
        BlocProvider<AuthenticationBloc>(
          create: (context) => AuthenticationBloc(
              authenticationRepository: authenticationRepository)
            ..add(CheckUserLoggedInStatus()),
        ),
        BlocProvider<ScrollToTopBloc>(
          create: (context) => ScrollToTopBloc(),
        ),
        BlocProvider<CreateProfileBloc>(
          create: (context) => CreateProfileBloc(),
        ),
        BlocProvider<CreatePostBloc>(
          create: (context) => CreatePostBloc(),
        ),
        BlocProvider(
          create: (context) =>
              UserPostBloc(userPostRepository: userPostRepository),
        ),
        BlocProvider<AllPostBloc>(
            create: (context) =>
                AllPostBloc(allPostRepository: allPostRepository)),
        BlocProvider<AccountPostBloc>(
          create: (context) =>
              AccountPostBloc(accountPostRepository: accountPostRepository),
        ),
        BlocProvider<AuthPostBloc>(
          create: (context) =>
              AuthPostBloc(authPostRepository: authPostRepository),
        ),
        BlocProvider<FollowUnfollowBloc>(
          create: (context) => FollowUnfollowBloc(),
        ),
        BlocProvider<DeletePostBloc>(
          create: (context) => DeletePostBloc(),
        ),
        BlocProvider<SearchTextFieldBloc>(
          create: (context) => SearchTextFieldBloc(),
        ),
        BlocProvider<SearchPostBloc>(
          create: (context) =>
              SearchPostBloc(searchPostRepository: searchPostRepository),
        ),
        BlocProvider<AuthSearchPostBloc>(
          create: (context) => AuthSearchPostBloc(
              authSearchPostRepository: authSearchPostRepository),
        ),
        BlocProvider<SearchAccountBloc>(
          create: (context) => SearchAccountBloc(
              searchAccountRepository: searchAccountRepository),
        ),
        BlocProvider<AccountInfoBloc>(
          create: (context) => AccountInfoBloc(),
        ),
        BlocProvider<AccountListBloc>(
          create: (context) => AccountListBloc(),
        ),
        BlocProvider<FollowingPostBloc>(
          create: (context) => FollowingPostBloc(),
        ),
        BlocProvider<FcmTokenBloc>(
          create: (context) => FcmTokenBloc(),
        ),
        BlocProvider<NotificationBloc>(
          create: (context) => NotificationBloc(),
        ),
        BlocProvider<FollowedAccountBloc>(
          create: (context) => FollowedAccountBloc(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.red,
          brightness: Brightness.light,
        ),
        debugShowCheckedModeBanner: false,
        home: Root(),
      ),
    );
  }
}

class Root extends StatefulWidget {
  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  void _toastNotification(
      String txt, Color color, Toast length, ToastGravity gravity) {
    // close active toast if any before open new one
    Fluttertoast.cancel();

    Fluttertoast.showToast(
      msg: '$txt',
      toastLength: length,
      gravity: gravity,
      timeInSecForIosWeb: 1,
      backgroundColor: color,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NetworkBloc, NetworkStates>(
      listener: (context, state) {
        if (state is ConnectionSuccess) {
          if (state.prevState is ConnectionFailure) {
            _toastNotification('Back online.', Colors.teal, Toast.LENGTH_SHORT,
                ToastGravity.BOTTOM);
          }
        } else if (state is ConnectionFailure) {
          _toastNotification('No internet connection.', Colors.red,
              Toast.LENGTH_SHORT, ToastGravity.BOTTOM);
        }
      },
      child: BlocBuilder<UserAppVisitBloc, UserAppVisitStates>(
        builder: (context, state) {
          if (state is UserAppVisitInitial) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (state is IsNotFirstTime) {
            return AppInitRoot();
          } else if (state is IsFirstTime) {
            return WelcomeScreen();
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
