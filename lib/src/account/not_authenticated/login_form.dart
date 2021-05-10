import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:windowshoppi/src/widget/widget_files.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  // form data
  String _userName, _passWord;

  Widget _divider() {
    return SizedBox(
      height: 20.0,
    );
  }

  Widget _buildUsernameTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(0.0),
          alignment: Alignment.centerLeft,
          child: TextFormField(
            inputFormatters: [
              LowerCaseTextFormatter(),
            ],
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.alternate_email, color: Colors.black54),
              labelText: 'Username*',
              border: OutlineInputBorder(),
              isDense: true,
            ),
            validator: (value) {
              var data = value.trim();
              if (data.isEmpty) {
                return 'username is required';
              }
              return null;
            },
//             onChanged: (value) async {
//               setState(() {
//                 _isUsernameLoading = true;
//                 _isUserExists = false;
//               });
//               // check validation .start
//               var data = value.trim();
//               if (data.length >= 5 && !data.contains(' ')) {
//                 var usernameData = {
//                   'username': data,
//                 };
//                 var res = await _checkUsername(usernameData);
//
//                 if (res['user_exists'] == true) {
//                   _isUsernameGood = false;
//                   _isUserExists = true;
//                 } else {
//                   _isUserExists = false;
//                   _isUsernameGood = true;
//                 }
//               } else if (value.length == 0) {
//                 _isUsernameGood = false;
//                 _isUserExists = false;
//               } else {
//                 _isUsernameGood = false;
//               }
//
//               setState(() {
//                 _isUsernameLoading = false;
//               });
//
// //              if (value.length > 5) {
// //                setState(() {
// //                  _isUsernameGood = true;
// //                });
// //              } else if (value.length == 0) {
// //                _isUsernameLoading = false;
// //                _isUsernameGood = false;
// //              } else {
// //                setState(() {
// //                  _isUsernameGood = false;
// //                });
// //              }
//             },
            onSaved: (value) => _userName = value,
          ),
        ),
      ],
    );
  }

  // Initially password is obscure
  bool _obscureText = true;

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(0.0),
          alignment: Alignment.centerLeft,
          child: TextFormField(
            obscureText: _obscureText,
            decoration: InputDecoration(
              labelText: 'Password*',
              prefixIcon: Icon(
                Icons.lock_outline,
                color: Colors.black54,
              ),
              suffixIcon: IconButton(
                onPressed: _toggle,
                icon: _obscureText
                    ? Icon(
                        Icons.visibility_off,
                        color: Colors.grey,
                      )
                    : Icon(
                        Icons.visibility,
                        color: Colors.grey[700],
                      ),
              ),
              contentPadding: EdgeInsets.symmetric(
                vertical: 0.0,
                horizontal: 10.0,
              ),
              border: OutlineInputBorder(),
              isDense: true,
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'password is required';
              }
              return null;
            },
            onSaved: (value) => _passWord = value,
          ),
        ),
      ],
    );
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Widget _buildForgotPasswordBtn() {
    return Align(
      alignment: Alignment.topRight,
      child: FlatButton(
        onPressed: () {
          // Navigator.push(
          //   context,
          //   FadeRoute(
          //     widget: DiscoverAccount(),
          //   ),
          // );
        },
        child: Text(
          'Forgot Password?',
          // style: kLabelStyle,
        ),
      ),
    );
  }

  Widget _buildLoginBtn() {
    return BlocConsumer<LoginBloc, LoginStates>(
      listener: (context, LoginStates state) async {
        if (state is LoginFormSubmitting) {
          return showDialog(
            barrierDismissible: false,
            context: context,
            builder: (dialogContext) => WillPopScope(
              onWillPop: () async => false,
              child: Material(
                type: MaterialType.transparency,
                child: Center(
                  // Aligns the container to center
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        'Please wait..',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        } else if (state is LoginNoInternet) {
          Navigator.of(context, rootNavigator: true).pop();
          _toastNotification('No internet connection', Colors.red,
              Toast.LENGTH_SHORT, ToastGravity.CENTER);
        } else if (state is LoginFormError) {
          await Future.delayed(Duration(milliseconds: 300), () {
            Navigator.of(context, rootNavigator: true).pop();
            _toastNotification('Sorry, login failed. try again', Colors.red,
                Toast.LENGTH_LONG, ToastGravity.SNACKBAR);
          });
        } else if (state is ValidAccount) {
          BlocProvider.of<AuthenticationBloc>(context).add(UserLoggedIn(
              user: state.user,
              isAlertDialogActive: {'status': true, 'activeDialog': 1}));
        } else if (state is InvalidAccount) {
          await Future.delayed(Duration(milliseconds: 300), () {
            Navigator.of(context, rootNavigator: true).pop();
            _toastNotification('wrong username or password', Colors.red,
                Toast.LENGTH_LONG, ToastGravity.SNACKBAR);
          });
        }
      },
      builder: (context, LoginStates state) {
        return Container(
          width: double.infinity,
          child: OutlineButton(
            splashColor: Colors.red,
            onPressed: () {
              FocusScope.of(context).requestFocus(FocusNode());

              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                dynamic loginInfo = {
                  'user_name': _userName,
                  'password': _passWord,
                };

                BlocProvider.of<LoginBloc>(context)
                    .add(UserLogin(data: loginInfo));
              }
            },
            child: Text('LOGIN'),
          ),
        );
      },
    );
  }

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
        fontSize: 14.0);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.account_circle,
                    color: Colors.grey[350],
                    size: 90,
                  ),
                  _divider(),
                  Text(
                    'WINDOWSHOPPI',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Text(
                    'Sign in with your account',
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.grey,
                    ),
                  ),
                  _divider(),
                  _buildUsernameTF(),
                  _divider(),
                  _buildPasswordTF(),
                  _buildForgotPasswordBtn(),
                  _buildLoginBtn(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
