import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:windowshoppi/utilities/constants.dart';
import 'package:windowshoppi/routes/fade_transition.dart';
import 'discover_account.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _rememberMe = false;

  // Initially password is obscure
  bool _obscureText = true;

  // form data
  String _userName, _passWord;

  Widget _buildWindowshoppiTitle() {
    return Column(
      children: <Widget>[
        Text(
          'windowshoppi',
          style: TextStyle(fontSize: 28, fontFamily: 'Itim'),
        ),
      ],
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
            decoration: InputDecoration(
              labelText: 'username',
              prefixIcon: Icon(Icons.person_outline),
              contentPadding: EdgeInsets.symmetric(
                vertical: 0.0,
                horizontal: 10.0,
              ),
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14.0),
                borderSide: BorderSide(
                  color: Colors.teal[900],
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(
                  color: Colors.teal[400],
                ),
              ),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'username is required';
              }
              return null;
            },
            onSaved: (value) => _userName = value,
          ),
        ),
      ],
    );
  }

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
              labelText: 'password',
              prefixIcon: Icon(Icons.lock_outline),
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
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14.0),
                borderSide: BorderSide(
                  color: Colors.teal[900],
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(
                  color: Colors.teal[400],
                ),
              ),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'password is required';
              } else if (value.length < 4) {
                return 'password must be greater than 4 character long';
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
    return Container(
      alignment: Alignment.centerRight,
      child: FlatButton(
        onPressed: () {
          Navigator.push(
              context,
              FadeRoute(
                widget: DiscoverAccount(),
              ));
        },
        child: Text(
          'Forgot Password?',
          style: kLabelStyle,
        ),
      ),
    );
  }

  Widget _buildRememberMeCheckbox() {
    return Container(
      height: 20.0,
      child: Row(
        children: <Widget>[
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: Checkbox(
              value: _rememberMe,
              checkColor: Colors.green,
              activeColor: Colors.white,
              onChanged: (value) {
                setState(() {
                  _rememberMe = value;
                });
              },
            ),
          ),
          Text(
            'remember me',
            style: kLabelStyle,
          ),
        ],
      ),
    );
  }

  Widget _buildLoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.0),
      width: double.infinity,
      child: RaisedButton(
        onPressed: () {},
        color: Colors.white,
        child: Text(
          'LOGIN',
          style: TextStyle(
            color: Colors.teal,
            letterSpacing: 1.5,
            fontWeight: FontWeight.bold,
            fontSize: 14.0,
          ),
        ),
      ),
    );
  }

  Widget _buildSignWithText() {
    return Column(
      children: <Widget>[
        Text(
          '- OR -',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(
          height: 15.0,
        ),
        Text(
          'Sign with',
          style: kLabelStyle,
        ),
      ],
    );
  }

  Widget _buildSocialBtn(Function onTap, AssetImage logo) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 30.0,
        width: 30.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black87,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
          image: DecorationImage(
            image: logo,
          ),
        ),
      ),
    );
  }

  Widget _buildSocialBtnRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildSocialBtn(() => print('login with facebook'),
              AssetImage('images/logo/facebook.jpg')),
          _buildSocialBtn(() => print('login with google'),
              AssetImage('images/logo/google.jpg')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Center(
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 40.0, vertical: 30.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          _buildWindowshoppiTitle(),
                          SizedBox(
                            height: 25.0,
                          ),
                          _buildUsernameTF(),
                          SizedBox(
                            height: 25.0,
                          ),
                          _buildPasswordTF(),
                          _buildForgotPasswordBtn(),
//                          _buildRememberMeCheckbox(),
                          _buildLoginBtn(),
//                          _buildSignWithText(),
//                          _buildSocialBtnRow(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
//              Column(
//                mainAxisAlignment: MainAxisAlignment.end,
//                children: <Widget>[
//                  Divider(),
//                  GestureDetector(
//                    onTap: () => Navigator.push(
//                      context,
//                      FadeRoute(
//                        widget: RegisterPage(),
//                      ),
//                    ),
//                    child: Card(
//                      color: Colors.black,
//                      child: Container(
//                        padding: EdgeInsets.symmetric(vertical: 10.0),
//                        alignment: Alignment.center,
//                        width: double.infinity,
//                        child: _buildSignUpBtn(),
//                      ),
//                    ),
//                  ),
//                ],
//              ),
            ],
          ),
        ),
      ),
    );
  }
}
