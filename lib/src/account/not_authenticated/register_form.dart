import 'dart:async';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:windowshoppi/src/widget/widget_files.dart';
import 'package:data_connection_checker/data_connection_checker.dart';

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();

  // form data
  String _firstName;
  String _lastName;
  String _phoneNumber;
  String _userName;
  String _passWord;
  String _emailAddress;

  // String initialCountry = 'TZ';
  PhoneNumber number = PhoneNumber(isoCode: 'TZ');
  String _enteredPhoneNumber;
  String _selectedIsoCode;
  String _selectedDialCode;

  Widget _divider() {
    return SizedBox(
      height: 20.0,
    );
  }

  Widget _buildFirstNameTF() {
    return Expanded(
      child: TextFormField(
        decoration: InputDecoration(
          // prefixIcon: Icon(Icons.account_circle, color: Colors.black54),
          labelText: 'First Name*',
          border: OutlineInputBorder(),
          isDense: true,
        ),
        validator: (value) {
          if (value.isEmpty) {
            return 'First name is required';
          }
          return null;
        },
        onSaved: (value) => _firstName = value,
      ),
    );
  }

  Widget _buildLastNameTF() {
    return Expanded(
      child: TextFormField(
        decoration: InputDecoration(
          // prefixIcon: Icon(Icons.account_circle, color: Colors.black54),
          labelText: 'Last Name*',
          border: OutlineInputBorder(),
          isDense: true,
        ),
        validator: (value) {
          if (value.isEmpty) {
            return 'Fast name is required';
          }
          return null;
        },
        onSaved: (value) => _lastName = value,
      ),
    );
  }

  Widget _buildPhoneNumberTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        InternationalPhoneNumberInput(
          inputDecoration: InputDecoration(
            labelText: 'Phone number*',
            border: OutlineInputBorder(),
            isDense: true,
          ),
          onInputChanged: (PhoneNumber number) {
            setState(() {
              _enteredPhoneNumber = number.phoneNumber;
              _selectedIsoCode = number.isoCode;
              _selectedDialCode = number.dialCode;
            });
            _phoneNumber =
                _enteredPhoneNumber.replaceFirst('${number.dialCode}', '');
          },
          // onInputValidated: (bool value) {
          //   // print(value);
          // },
          // onSaved: (value) => _phoneNumber = _enteredPhoneNumber,
          selectorConfig: SelectorConfig(
            selectorType: PhoneInputSelectorType.DIALOG,
          ),
          ignoreBlank: false,
          autoValidateMode: AutovalidateMode.disabled,
          selectorTextStyle: TextStyle(color: Colors.black),
          initialValue: number,
          inputBorder: OutlineInputBorder(),
        ),
        if (_enteredPhoneNumber != null)
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '$_enteredPhoneNumber',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
      ],
    );
  }

  bool _isUserExists = false;

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
              Pattern pattern = r'^[A-Za-z0-9]+(?:[_][A-Za-z0-9]+)*$';
              RegExp regex = new RegExp(pattern);

              var data = value.trim();

              if (data.isEmpty) {
                return 'Username is required';
              } else if (data.contains(' ')) {
                return 'Space between username is not required';
              } else if (data.contains('-')) {
                return 'Dash is not required in username';
              } else if (data.length < 5) {
                return 'Username must be greater than 5 character long';
              } else if (!regex.hasMatch(data)) {
                return 'Invalid username';
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
        Visibility(
          visible: _isUserExists ? true : false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
            child: Text(
              'Username already exists',
              style: TextStyle(color: Colors.red[400], fontSize: 12.0),
            ),
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
              Pattern pattern = r'^[A-Za-z0-9]+(?:[ _-][A-Za-z0-9]+)*$';
              RegExp regex = new RegExp(pattern);

              var data = value.trim();

              if (value.isEmpty) {
                return 'Password is required';
              } else if (value.length < 4) {
                return 'Password must be greater than 4 character long';
              } else if (!regex.hasMatch(data)) {
                return 'Invalid password';
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

  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(0.0),
          alignment: Alignment.centerLeft,
          child: TextFormField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email Address',
              prefixIcon: Icon(
                Icons.email,
                color: Colors.black54,
              ),
              border: OutlineInputBorder(),
              isDense: true,
            ),
            validator: (value) {
              Pattern pattern =
                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
              RegExp regExp = new RegExp(pattern);

              if (value.isNotEmpty) {
                if (!regExp.hasMatch(value)) {
                  return 'Please enter valid email';
                }
              }
              return null;
            },
            onSaved: (value) => _emailAddress = value,
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterBtn() {
    return BlocConsumer<RegistrationBloc, RegistrationStates>(
      listener: (context, RegistrationStates state) async {
        if (state is FormSubmitting) {
          return showDialog(
            barrierDismissible: false,
            context: context,
            builder: (dialogContext) => Material(
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
                      'Saving..',
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
          );
        } else if (state is FormError) {
          await Future.delayed(Duration(milliseconds: 300), () {
            Navigator.of(context, rootNavigator: true).pop();
            // _notification(
            //     'Error occurred, please try again.', Colors.red, Colors.white);
            _toastNotification('Error occurred, please try again.', Colors.red,
                Toast.LENGTH_LONG, ToastGravity.SNACKBAR);
          });
        } else if (state is UserExist) {
          await Future.delayed(Duration(milliseconds: 300), () {
            Navigator.of(context, rootNavigator: true).pop();
          });
          setState(() {
            _isUserExists = true;
          });
        } else if (state is FormSubmitted) {
          BlocProvider.of<AuthenticationBloc>(context).add(UserLoggedIn(
              user: state.user,
              isAlertDialogActive: {'status': true, 'activeDialog': 1}));
        }
      },
      builder: (context, RegistrationStates state) {
        return BlocConsumer<NetworkBloc, NetworkStates>(
          listener: (context, state) {
            if (state is ConnectionSuccess) {
              if (state.prevState is ConnectionFailure) {
                _toastNotification('Back online', Colors.teal,
                    Toast.LENGTH_SHORT, ToastGravity.CENTER);
              }
            } else if (state is ConnectionFailure) {
              _toastNotification('No internet connection', Colors.red,
                  Toast.LENGTH_SHORT, ToastGravity.CENTER);
            }
          },
          builder: (context, state) {
            return Container(
              width: double.infinity,
              child: OutlineButton(
                splashColor: Colors.red,
                onPressed: () async {
                  FocusScope.of(context).requestFocus(FocusNode());

                  if (_formKey.currentState.validate()) {
                    if (state is ConnectionSuccess) {
                      _formKey.currentState.save();
                      dynamic userData = {
                        'first_name': _firstName,
                        'last_name': _lastName,
                        'call': _phoneNumber,
                        'call_iso_code': _selectedIsoCode,
                        'call_dial_code': _selectedDialCode,
                        'username': _userName,
                        'password': _passWord,
                        if (_emailAddress != '') 'email': _emailAddress,
                        'group': 'windowshopper',
                      };

                      BlocProvider.of<RegistrationBloc>(context)
                          .add(SaveUserData(data: userData));
                    } else if (state is ConnectionFailure) {
                      _toastNotification('No internet connection.', Colors.red,
                          Toast.LENGTH_SHORT, ToastGravity.CENTER);
                    } else {
                      return Container();
                    }
                  }
                },
                child: Text('REGISTER'),
              ),
            );
          },
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

  // void _setNumbers() {
  //   print('set number');
  //   number = PhoneNumber(isoCode: 'KE', phoneNumber: '653900085');
  // }

  @override
  void initState() {
    // _setNumbers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        children: [
          Container(
            padding: EdgeInsets.only(top: 20.0),
            alignment: Alignment.center,
            child: Text(
              'CREATE ACCOUNT',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Text(
              'Enter your details below',
              style: TextStyle(
                fontSize: 12.0,
                color: Colors.grey,
              ),
            ),
          ),
          _divider(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: [
                      _buildFirstNameTF(),
                      SizedBox(
                        width: 3.0,
                      ),
                      _buildLastNameTF(),
                    ],
                  ),
                  _divider(),
                  _buildPhoneNumberTF(),
                  _divider(),
                  _buildUsernameTF(),
                  _divider(),
                  _buildPasswordTF(),
                  _divider(),
                  _buildEmailTF(),
                  // _divider(),
                  // _buildSelectCountryDropDown(),
                  _divider(),
                  _buildRegisterBtn(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
