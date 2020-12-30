import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';

class SwitchToBusinessForm extends StatefulWidget {
  @override
  _SwitchToBusinessFormState createState() => _SwitchToBusinessFormState();
}

class _SwitchToBusinessFormState extends State<SwitchToBusinessForm> {
  final _formKey = GlobalKey<FormState>();

  // form data
  String _businessName,
      _userName,
      _businessType,
      _phoneNumber,
      _whatsappNumber,
      _accountBio,
      _emailAddress;

  Widget _divider() {
    return SizedBox(
      height: 20.0,
    );
  }

  Widget _buildBusinessAccountNameTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(0.0),
          alignment: Alignment.centerLeft,
          child: TextFormField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.business_center, color: Colors.black54),
              labelText: 'Business Name*',
              border: OutlineInputBorder(),
              isDense: true,
            ),
            validator: (value) {
              var data = value.trim();
              if (data.isEmpty) {
                return 'Business Name is required';
              }
              return null;
            },
            onSaved: (value) => _businessName = value,
          ),
        ),
      ],
    );
  }

  bool _isUserExists = false;

  Widget _buildUsernameTF(initValue) {
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
            initialValue: initValue,
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

  Widget _buildBusinessTypeTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(0.0),
          alignment: Alignment.centerLeft,
          child: TextFormField(
            maxLength: 30,
            decoration: InputDecoration(
              labelText: 'What does your Business Do',
              prefixIcon: Icon(Icons.category, color: Colors.black54),
              contentPadding: EdgeInsets.all(10.0),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              var data = value.trim();
              if (data.isEmpty) {
                return 'This field is required';
              }
              return null;
            },
            onSaved: (value) => _businessType = value,
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneNumberTF(initValue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(0.0),
          alignment: Alignment.centerLeft,
          child: TextFormField(
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.phone, color: Colors.black54),
              labelText: 'Phone number*',
              border: OutlineInputBorder(),
              isDense: true,
            ),
            validator: (value) {
              String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
              RegExp regExp = new RegExp(pattern);
              if (value.isEmpty) {
                return 'phone number is required';
              } else if (!regExp.hasMatch(value)) {
                return 'Please enter valid phone number';
              }
              return null;
            },
            initialValue: initValue,
            onSaved: (value) => _phoneNumber = value,
          ),
        ),
      ],
    );
  }

  Widget _buildWhatsappNumberTF(initValue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(0.0),
          alignment: Alignment.centerLeft,
          child: TextFormField(
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.phone, color: Colors.black54),
              labelText: 'Whatsapp number*',
              border: OutlineInputBorder(),
              isDense: true,
            ),
            validator: (value) {
              String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
              RegExp regExp = new RegExp(pattern);
              if (value.isEmpty) {
                return null;
              } else if (!regExp.hasMatch(value)) {
                return 'Please enter valid whatsapp number';
              }
              return null;
            },
            initialValue: initValue,
            onSaved: (value) => _whatsappNumber = value,
          ),
        ),
      ],
    );
  }

  Widget _buildAccountBioTF(initValue) {
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
            initialValue: initValue,
            onSaved: (value) => _accountBio = value,
          ),
        ),
      ],
    );
  }

  Widget _buildEmailTF(initValue) {
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
            initialValue: initValue,
            onSaved: (value) => _emailAddress = value,
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchToBusinessBtn() {
    return BlocBuilder<AuthenticationBloc, AuthenticationStates>(
      builder: (context, state) {
        if (state is IsAuthenticated) {
          var data = state.user;
          return BlocListener<SwitchToBusinessBloc, SwitchToBusinessStates>(
            listener: (context, state) async {
              if (state is SwitchToBusinessSubmitting) {
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
              } else if (state is SwitchToBusinessFormError) {
                await Future.delayed(Duration(milliseconds: 300), () {
                  Navigator.of(context, rootNavigator: true).pop();
                  _notification('Error occurred, please try again.', Colors.red,
                      Colors.white);
                });
              } else if (state is SwitchToBusinessUserExist) {
                await Future.delayed(Duration(milliseconds: 300), () {
                  Navigator.of(context, rootNavigator: true).pop();
                });
                setState(() {
                  _isUserExists = true;
                });
              } else if (state is SwitchToBusinessFormSubmitted) {
                BlocProvider.of<AuthenticationBloc>(context).add(
                  UserUpdated(
                    user: state.user,
                    isAlertDialogActive: {'status': true, 'activeDialog': 3},
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

                    dynamic businessData = {
                      'group': 'vendor',
                      'account_name': _businessName,
                      'username': _userName,
                      'business_bio': _businessType,
                      'call': _phoneNumber,
                      if (_whatsappNumber != '') 'whatsapp': _whatsappNumber,
                      if (_accountBio != '') 'account_bio': _accountBio,
                      if (_emailAddress != '') 'email': _emailAddress,
                    };

                    BlocProvider.of<SwitchToBusinessBloc>(context)
                      ..add(SwitchToBusinessAccount(
                        accountId: data.accountId,
                        contactId: data.contactId,
                        data: businessData,
                      ));
                  }
                },
                child: Text('SWITCH TO BUSINESS'),
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  void _notification(String txt, Color bgColor, Color btnColor) {
    Scaffold.of(context)
        .hideCurrentSnackBar(); // hide current snackBar if is active before open new one
    final snackBar = SnackBar(
      content: Text(txt),
      backgroundColor: bgColor,
      action: SnackBarAction(
        label: 'Hide',
        textColor: btnColor,
        onPressed: () {
          Scaffold.of(context).hideCurrentSnackBar();
        },
      ),
    );
    Scaffold.of(context).showSnackBar(snackBar);
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
                'SWITCH TO BUSINESS ACCOUNT',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                'Edit your details below and fill in the blanks',
                style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.grey,
                ),
              ),
            ),
            _divider(),
            BlocBuilder<AuthenticationBloc, AuthenticationStates>(
              builder: (context, state) {
                if (state is IsAuthenticated) {
                  var data = state.user;
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          _buildBusinessAccountNameTF(),
                          _divider(),
                          _buildUsernameTF(data.username),
                          _divider(),
                          _buildBusinessTypeTF(),
                          _divider(),
                          _buildPhoneNumberTF(data.call),
                          _divider(),
                          _buildWhatsappNumberTF(data.whatsapp),
                          _divider(),
                          _buildAccountBioTF(data.accountBio),
                          _divider(),
                          _buildEmailTF(data.email),
                          _divider(),
                          _buildSwitchToBusinessBtn(),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
