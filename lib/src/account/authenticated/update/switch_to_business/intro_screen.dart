import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:windowshoppi/src/account/account_files.dart';
import 'package:windowshoppi/src/model/model_files.dart';

class IntroScreen extends StatefulWidget {
  final User user;
  IntroScreen({@required this.user}) : super();
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final _introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SwitchToBusinessInit(
          user: widget.user,
        ),
      ),
    );
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
          title: 'Get Free Business Account',
          body:
              'With business account you get special badge on every Post you create that tells people about your business.',
          decoration: pageDecoration,
          image: Align(
            child: Image.asset(
              'assets/image/free_business_account.png',
            ),
            alignment: Alignment.bottomCenter,
          ),
        ),
        PageViewModel(
          title: 'Reach More Customers',
          body:
              'People visit Windowshoppi to discover new ideas to try and interesting things for them. Create great contents and reach more customers.',
          decoration: pageDecoration,
          image: Align(
            child: Image.asset(
              'assets/image/announce.png',
            ),
            alignment: Alignment.bottomCenter,
          ),
        ),
        PageViewModel(
          title: 'Contact Options',
          body:
              'Your contacts will be made public and will be embedded to each post you make for customers to reach you easily.',
          decoration: pageDecoration,
          image: Align(
            child: Image.asset(
              'assets/image/vendor_contacts.png',
            ),
            alignment: Alignment.bottomCenter,
          ),
        ),
      ],
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      skip: const Text('Skip'),
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
