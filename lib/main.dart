import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:windowshoppi/navigation_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windowshoppi/Overseer.dart';
import 'package:windowshoppi/Provider.dart';
import 'package:flutter/material.dart';
import 'package:sentry/sentry.dart';
import 'package:windowshoppi/src/repository/repository_files.dart';
import 'dart:async';
import 'dsn.dart';
import 'package:http/http.dart' as http;

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
    runApp(
      MyApp(),
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

  @override
  Widget build(BuildContext context) {
    return Provider(
      data: Overseer(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthenticationBloc>(
            create: (context) => AuthenticationBloc(
                authenticationRepository: authenticationRepository)
              ..add(CheckUserLoggedInStatus()),
          ),
        ],
        child: MaterialApp(
          theme: ThemeData(
            primarySwatch: Colors.red,
            brightness: Brightness.light,
          ),
          home: AppNavigation(),
        ),
      ),
    );
  }
}
