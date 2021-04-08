import 'package:introduction_screen/introduction_screen.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    BlocProvider.of<UserAppVisitBloc>(context)..add(SurveyFinished());
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 16.0);

    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      // descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      // pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      globalBackgroundColor: Colors.white,
      key: _introKey,
      pages: [
        PageViewModel(
          title: 'Discover',
          body: 'Explore lifestyle inspiration and find new ideas to try.',
          decoration: pageDecoration,
          image: Align(
            child: Image.asset(
              'assets/image/discover.png',
            ),
            alignment: Alignment.bottomCenter,
          ),
        ),
        PageViewModel(
          title: 'Share',
          body:
              'Share and recommend great things you have discovered to people like you.',
          decoration: pageDecoration,
          image: Align(
            child: Image.asset(
              'assets/image/share.png',
            ),
            alignment: Alignment.bottomCenter,
          ),
        ),
        PageViewModel(
          title: 'Windowshoppi location tags',
          body:
              'Add location to the post to show amazing places you have visited, e.g. local restaurant, clothing store etc',
          decoration: pageDecoration,
          image: Align(
            child: Image.asset(
              'assets/image/tag_location.png',
            ),
            alignment: Alignment.bottomCenter,
          ),
        ),
      ],
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      skip: Text('Skip'),
      next: const Icon(Icons.arrow_forward),
      onDone: () => _onIntroEnd(context),
      done: Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: const DotsDecorator(
        activeColor: Colors.red,
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}
