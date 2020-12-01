import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:windowshoppi/src/account/account_files.dart';

class LoginRegister extends StatefulWidget {
  final bool registerIsActive;
  LoginRegister({@required this.registerIsActive});

  @override
  _LoginRegisterState createState() => _LoginRegisterState();
}

class _LoginRegisterState extends State<LoginRegister> {
  bool _registerIsActive = true;

  void _togglePage() {
    setState(() {
      _registerIsActive = !_registerIsActive;
    });
  }

  @override
  void didChangeDependencies() {
    setState(() {
      _registerIsActive = widget.registerIsActive;
    });

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 2.0),
                      child: RaisedButton(
                        onPressed: _registerIsActive ? null : _togglePage,
                        textColor: Theme.of(context).colorScheme.onPrimary,
                        color: Theme.of(context).colorScheme.primary,
                        child: const Text('REGISTER'),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 2.0),
                      child: RaisedButton(
                        onPressed: _registerIsActive ? _togglePage : null,
                        color: Theme.of(context).colorScheme.primary,
                        textColor: Theme.of(context).colorScheme.onPrimary,
                        child: const Text('LOGIN'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(thickness: 2.0),
            Expanded(
              child: PageTransitionSwitcher(
                duration: const Duration(milliseconds: 300),
                reverse: _registerIsActive,
                transitionBuilder: (
                  Widget child,
                  Animation<double> animation,
                  Animation<double> secondaryAnimation,
                ) {
                  return SharedAxisTransition(
                    child: child,
                    animation: animation,
                    secondaryAnimation: secondaryAnimation,
                    transitionType: SharedAxisTransitionType.horizontal,
                  );
                },
                child: _registerIsActive ? RegisterInit() : LoginInit(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
