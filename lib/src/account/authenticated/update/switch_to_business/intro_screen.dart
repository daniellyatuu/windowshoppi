import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:windowshoppi/src/account/account_files.dart';

class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final _introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => SwitchToBusinessInit()),
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
              'With business account, you get special badge on every Post you create on Windowshoppi that tells people about your business',
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
              'Create good post on Windowshoppi to help reach more customers and make your business grow.',
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
              'Your contacts will be public inorder for customer to reach you by phone call or whatsapp chart easy.',
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
        activeColor: Color(0xFF4D8AF0),
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
