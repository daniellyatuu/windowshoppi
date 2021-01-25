import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:windowshoppi/src/model/model_files.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SwitchToBusinessForm extends StatefulWidget {
  final User user;
  SwitchToBusinessForm({@required this.user}) : super();

  @override
  _SwitchToBusinessFormState createState() => _SwitchToBusinessFormState();
}

class _SwitchToBusinessFormState extends State<SwitchToBusinessForm> {
  final _formKey = GlobalKey<FormState>();

  // form data
  String _businessName;
  String _userName;
  String _businessType;
  String _phoneNumber;
  String _whatsappNumber;
  String _accountBio;
  String _emailAddress;

  //for call number
  PhoneNumber callNumber = PhoneNumber();
  String _enteredCallNumber;
  String _selectedCallIsoCode;
  String _selectedCallDialCode;

  //for whatsapp number
  PhoneNumber whatsappNumber = PhoneNumber();
  String _enteredWhatsappNumber;
  String _selectedWhatsappIsoCode;
  String _selectedWhatsappDialCode;

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

  Widget _buildCallNumberTF() {
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
              _enteredCallNumber = number.phoneNumber;
              _selectedCallIsoCode = number.isoCode;
              _selectedCallDialCode = number.dialCode;
            });
            _phoneNumber =
                _enteredCallNumber.replaceFirst('${number.dialCode}', '');
          },
          selectorConfig: SelectorConfig(
            selectorType: PhoneInputSelectorType.DIALOG,
          ),
          ignoreBlank: false,
          autoValidateMode: AutovalidateMode.disabled,
          selectorTextStyle: TextStyle(color: Colors.black),
          initialValue: callNumber,
          inputBorder: OutlineInputBorder(),
        ),
        if (_enteredCallNumber != null)
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '$_enteredCallNumber',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
      ],
    );
  }

  Widget _buildWhatsappNumberTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        InternationalPhoneNumberInput(
          validator: (value) {
            value = value.replaceAll(' ', '');
            String pattern = r'(^(?:[+0]9)?[0-9]{8,15}$)';
            RegExp regExp = new RegExp(pattern);
            if (value.isEmpty) {
              return null;
            } else if (!regExp.hasMatch(value)) {
              return 'Please enter valid whatsapp number';
            }
            return null;
          },
          inputDecoration: InputDecoration(
            labelText: 'Whatsapp number',
            border: OutlineInputBorder(),
            isDense: true,
          ),
          onInputChanged: (PhoneNumber number) {
            setState(() {
              _enteredWhatsappNumber = number.phoneNumber;
              _selectedWhatsappIsoCode = number.isoCode;
              _selectedWhatsappDialCode = number.dialCode;
            });
            _whatsappNumber =
                _enteredWhatsappNumber.replaceFirst('${number.dialCode}', '');
          },
          selectorConfig: SelectorConfig(
            selectorType: PhoneInputSelectorType.DIALOG,
          ),
          ignoreBlank: false,
          autoValidateMode: AutovalidateMode.disabled,
          selectorTextStyle: TextStyle(color: Colors.black),
          initialValue: whatsappNumber,
          inputBorder: OutlineInputBorder(),
        ),
        if (_enteredWhatsappNumber != null)
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '$_enteredWhatsappNumber',
              style: Theme.of(context).textTheme.bodyText1,
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
            onSaved: (value) => _accountBio = value,
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
            onSaved: (value) => _emailAddress = value,
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchToBusinessBtn() {
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
        } else if (state is SwitchAccountNoInternet) {
          Navigator.of(context, rootNavigator: true).pop();
          _toastNotification('No internet connection', Colors.red,
              Toast.LENGTH_SHORT, ToastGravity.CENTER);
        } else if (state is SwitchToBusinessFormError) {
          await Future.delayed(Duration(milliseconds: 300), () {
            Navigator.of(context, rootNavigator: true).pop();
            _toastNotification('Error occurred, please try again.', Colors.red,
                Toast.LENGTH_LONG, ToastGravity.SNACKBAR);
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
                'call_iso_code': _selectedCallIsoCode,
                'call_dial_code': _selectedCallDialCode,
                if (_whatsappNumber != null) 'whatsapp': _whatsappNumber,
                if (_whatsappNumber != null)
                  'whatsapp_iso_code': _selectedWhatsappIsoCode,
                if (_whatsappNumber != null)
                  'whatsapp_dial_code': _selectedWhatsappDialCode,
                if (_accountBio != '') 'account_bio': _accountBio,
                if (_emailAddress != '') 'email': _emailAddress,
              };

              BlocProvider.of<SwitchToBusinessBloc>(context)
                ..add(SwitchToBusinessAccount(
                  accountId: widget.user.accountId,
                  contactId: widget.user.contactId,
                  data: businessData,
                ));
            }
          },
          child: Text('SWITCH TO BUSINESS'),
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
    callNumber = PhoneNumber(
        isoCode: '${widget.user.callIsoCode}',
        phoneNumber: '${widget.user.call}');

    whatsappNumber = PhoneNumber(isoCode: '${widget.user.callIsoCode}');
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
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _buildBusinessAccountNameTF(),
                    _divider(),
                    _buildUsernameTF(),
                    _divider(),
                    _buildBusinessTypeTF(),
                    _divider(),
                    _buildCallNumberTF(),
                    _divider(),
                    _buildWhatsappNumberTF(),
                    _divider(),
                    _buildAccountBioTF(),
                    _divider(),
                    _buildEmailTF(),
                    _divider(),
                    _buildSwitchToBusinessBtn(),
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
