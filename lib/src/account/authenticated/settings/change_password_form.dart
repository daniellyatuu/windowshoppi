import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';

class ChangePasswordForm extends StatefulWidget {
  @override
  _ChangePasswordFormState createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<ChangePasswordForm> {
  final _formKey = GlobalKey<FormState>();

  // form data
  String _currentPassword, _newPassword, _confirmNewPassword;

  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmNewPassword = true;

  bool _isCurrentPasswordIncorrect = false;
  bool _isPasswordMisMatch = false;
  bool _isCurrentPasswordEqualToNewPassword = false;

  void _toggleCurrentPassword() {
    setState(() {
      _obscureCurrentPassword = !_obscureCurrentPassword;
    });
  }

  void _toggleNewPassword() {
    setState(() {
      _obscureNewPassword = !_obscureNewPassword;
    });
  }

  void _toggleConfirmNewPassword() {
    setState(() {
      _obscureConfirmNewPassword = !_obscureConfirmNewPassword;
    });
  }

  Widget _divider() {
    return SizedBox(
      height: 20.0,
    );
  }

  Widget _buildCurrentPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(0.0),
          alignment: Alignment.centerLeft,
          child: TextFormField(
            obscureText: _obscureCurrentPassword,
            decoration: InputDecoration(
              labelText: 'Current Password*',
              suffixIcon: IconButton(
                onPressed: _toggleCurrentPassword,
                icon: _obscureCurrentPassword
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
            onChanged: (value) {
              if (_isCurrentPasswordIncorrect) {
                setState(() {
                  _isCurrentPasswordIncorrect = false;
                });
              }
            },
            validator: (value) {
              if (value.isEmpty) {
                return 'Current password is required';
              }
              return null;
            },
            onSaved: (value) => _currentPassword = value,
          ),
        ),
        Visibility(
          visible: _isCurrentPasswordIncorrect ? true : false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
            child: Text(
              'Current password not valid',
              style: TextStyle(color: Colors.red[400], fontSize: 12.0),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNewPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(0.0),
          alignment: Alignment.centerLeft,
          child: TextFormField(
            obscureText: _obscureNewPassword,
            decoration: InputDecoration(
              labelText: 'New Password*',
              suffixIcon: IconButton(
                onPressed: _toggleNewPassword,
                icon: _obscureNewPassword
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
            onChanged: (value) {
              if (_isCurrentPasswordEqualToNewPassword) {
                setState(() {
                  _isCurrentPasswordEqualToNewPassword = false;
                });
              }
            },
            validator: (value) {
              Pattern pattern = r'^[A-Za-z0-9]+(?:[ _-][A-Za-z0-9]+)*$';
              RegExp regex = new RegExp(pattern);

              var data = value.trim();

              if (value.isEmpty) {
                return 'New password is required';
              } else if (value.length < 4) {
                return 'New password must be greater than 4 character long';
              } else if (!regex.hasMatch(data)) {
                return 'Invalid password';
              }
              return null;
            },
            onSaved: (value) => _newPassword = value,
          ),
        ),
        Visibility(
          visible: _isCurrentPasswordEqualToNewPassword ? true : false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
            child: Text(
              'New password and current password must not be the same.',
              style: TextStyle(color: Colors.red[400], fontSize: 12.0),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmNewPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(0.0),
          alignment: Alignment.centerLeft,
          child: TextFormField(
            obscureText: _obscureConfirmNewPassword,
            decoration: InputDecoration(
              labelText: 'Confirm New Password*',
              suffixIcon: IconButton(
                onPressed: _toggleConfirmNewPassword,
                icon: _obscureConfirmNewPassword
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
            onChanged: (value) {
              if (_isPasswordMisMatch) {
                setState(() {
                  _isPasswordMisMatch = false;
                });
              }
            },
            validator: (value) {
              if (value.isEmpty) {
                return 'Confirm new password is required';
              }
              return null;
            },
            onSaved: (value) => _confirmNewPassword = value,
          ),
        ),
        Visibility(
          visible: _isPasswordMisMatch ? true : false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
            child: Text(
              'Password not match',
              style: TextStyle(color: Colors.red[400], fontSize: 12.0),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUpdateBtn() {
    return Container(
      width: double.infinity,
      child: BlocListener<ChangePasswordBloc, ChangePasswordStates>(
        listener: (context, state) async {
          if (state is ChangePasswordFormSubmitting) {
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
                        'Updating..',
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
          } else if (state is InvalidCurrentPassword) {
            await Future.delayed(Duration(milliseconds: 300), () {
              Navigator.of(context, rootNavigator: true).pop();
              setState(() {
                _isCurrentPasswordIncorrect = true;
              });
            });
          } else if (state is ChangePasswordFormSubmitted) {
            for (int x = 0; x < 2; x++) {
              Navigator.of(context, rootNavigator: x == 0 ? true : false).pop();
            }
            _notification('Password changed successfully', Colors.teal);
          } else if (state is ChangePasswordFormError) {
            await Future.delayed(Duration(milliseconds: 300), () {
              Navigator.of(context).pop();
              _notification('Error occurred, please try again.', Colors.red);
            });
          }
        },
        child: OutlineButton(
          splashColor: Colors.red,
          onPressed: () async {
            FocusScope.of(context).requestFocus(FocusNode());

            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();

              bool isPasswordCorrect =
                  await confirmPassword(_newPassword, _confirmNewPassword);

              if (isPasswordCorrect) {
                bool isPrevPasswordEqualToNewPassword =
                    await confirmPassword(_currentPassword, _newPassword);

                if (!isPrevPasswordEqualToNewPassword) {
                  dynamic passwordData = {
                    'current_password': _currentPassword,
                    'new_password': _newPassword,
                  };

                  BlocProvider.of<ChangePasswordBloc>(context)
                    ..add(UpdateUserPassword(data: passwordData));
                } else {
                  setState(() {
                    _isCurrentPasswordEqualToNewPassword = true;
                  });
                }
              } else {
                setState(() {
                  _isPasswordMisMatch = true;
                });
              }
            }
          },
          child: Text('UPDATE'),
        ),
      ),
    );
  }

  Future<bool> confirmPassword(pass1, pass2) async {
    return pass1 == pass2;
  }

  void _notification(String txt, Color bgColor) {
    Scaffold.of(context).hideCurrentSnackBar();
    final snackBar = SnackBar(
      content: Text(txt),
      backgroundColor: bgColor,
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
      ),
      body: Form(
        // key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                _divider(),
                _buildCurrentPasswordTF(),
                _divider(),
                _buildNewPasswordTF(),
                _divider(),
                _buildConfirmNewPasswordTF(),
                _divider(),
                _buildUpdateBtn(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
