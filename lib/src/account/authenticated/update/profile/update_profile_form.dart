import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:windowshoppi/src/model/model_files.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UpdateProfileForm extends StatefulWidget {
  final User user;
  UpdateProfileForm({@required this.user}) : super();

  @override
  _UpdateProfileFormState createState() => _UpdateProfileFormState();
}

class _UpdateProfileFormState extends State<UpdateProfileForm> {
  final _formKey = GlobalKey<FormState>();

  // form data
  String _firstName;
  String _lastName;
  String _phoneNumber;
  String _userName;
  String _accountBio;
  String _emailAddress;

  PhoneNumber number = PhoneNumber();
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
        initialValue: widget.user.firstName,
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
        initialValue: widget.user.lastName,
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
            initialValue: widget.user.username,
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

  Widget _buildAccountBioTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(0.0),
          alignment: Alignment.centerLeft,
          child: TextFormField(
            maxLines: null,
            scrollPadding: EdgeInsets.all(10.0),
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              labelText: 'Account Bio',
              prefixIcon: Icon(Icons.text_fields, color: Colors.black54),
              contentPadding: EdgeInsets.all(10.0),
              border: OutlineInputBorder(),
            ),
            initialValue: widget.user.accountBio,
            onSaved: (value) =>
                value != '' ? _accountBio = value : _accountBio = null,
          ),
        ),
      ],
    );
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
            initialValue: widget.user.email,
            onSaved: (value) =>
                value != '' ? _emailAddress = value : _emailAddress = null,
          ),
        ),
      ],
    );
  }

  Widget _buildUpdateBtn() {
    return BlocListener<WindowshopperProfileUpdateBloc,
        WindowshopperProfileUpdateStates>(
      listener: (context, state) async {
        if (state is WindowshopperProfileUpdateSubmitting) {
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
            ),
          );
        } else if (state is WindowshopperProfileUpdateNoInternet) {
          Navigator.of(context, rootNavigator: true).pop();
          _toastNotification('No internet connection', Colors.red,
              Toast.LENGTH_SHORT, ToastGravity.CENTER);
        } else if (state is WindowshopperProfileUpdateFormError) {
          await Future.delayed(Duration(milliseconds: 300), () {
            Navigator.of(context, rootNavigator: true).pop();
            _toastNotification('Error occurred, please try again.', Colors.red,
                Toast.LENGTH_LONG, ToastGravity.SNACKBAR);
          });
        } else if (state is WindowshopperProfileUpdateUserExist) {
          await Future.delayed(Duration(milliseconds: 300), () {
            Navigator.of(context, rootNavigator: true).pop();
          });
          setState(() {
            _isUserExists = true;
          });
        } else if (state is WindowshopperProfileUpdateFormSubmitted) {
          BlocProvider.of<AuthenticationBloc>(context).add(
            UserUpdated(
              user: state.user,
              isAlertDialogActive: {'status': true, 'activeDialog': 2},
            ),
          );
        }
      },
      child: Container(
        width: double.infinity,
        child: OutlineButton(
          splashColor: Colors.red,
          onPressed: () {
            FocusScope.of(context).requestFocus(FocusNode());

            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();

              if (widget.user.firstName != _firstName ||
                  widget.user.lastName != _lastName ||
                  widget.user.call != _phoneNumber ||
                  widget.user.username != _userName ||
                  widget.user.accountBio != _accountBio ||
                  widget.user.email != _emailAddress ||
                  widget.user.callDialCode != _selectedDialCode) {
                dynamic userData = {
                  'first_name': _firstName,
                  'last_name': _lastName,
                  'call': _phoneNumber,
                  'call_iso_code': _selectedIsoCode,
                  'call_dial_code': _selectedDialCode,
                  if (_accountBio != null) 'account_bio': _accountBio,
                  'username': _userName,
                  if (_emailAddress != null) 'email': _emailAddress,
                };

                BlocProvider.of<WindowshopperProfileUpdateBloc>(context)
                  ..add(UpdateWindowshopperProfile(
                      accountId: widget.user.accountId,
                      contactId: widget.user.contactId,
                      data: userData));
              } else {
                _toastNotification('Change data and click update', Colors.black,
                    Toast.LENGTH_LONG, ToastGravity.SNACKBAR);
              }
            }
          },
          child: Text('UPDATE'),
        ),
      ),
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

  void _setCallNumber() {
    number = PhoneNumber(
        isoCode: '${widget.user.callIsoCode}',
        phoneNumber: '${widget.user.call}');
  }

  @override
  void initState() {
    _setCallNumber();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          children: [
            Container(
              padding: EdgeInsets.only(top: 20.0),
              alignment: Alignment.center,
              child: Text(
                'EDIT PROFILE',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                'Edit your details below',
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
                    _buildUsernameTF(),
                    _divider(),
                    _buildPhoneNumberTF(),
                    _divider(),
                    _buildAccountBioTF(),
                    _divider(),
                    _buildEmailTF(),
                    _divider(),
                    _buildUpdateBtn(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
