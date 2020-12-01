import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';

class WhatsappNumberForm extends StatefulWidget {
  @override
  _WhatsappNumberFormState createState() => _WhatsappNumberFormState();
}

class _WhatsappNumberFormState extends State<WhatsappNumberForm> {
  final _formKey = GlobalKey<FormState>();

  // form data
  String _whatsappNumber;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Enter whatsapp Number',
                style: Theme.of(context).textTheme.headline6,
              ),
              SizedBox(
                height: 20.0,
              ),
              ListView(
                shrinkWrap: true,
                children: [
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
                      onSaved: (value) => _whatsappNumber = value,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  OutlineButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Cancel'),
                  ),
                  BlocBuilder<AuthenticationBloc, AuthenticationStates>(
                    builder: (context, state) {
                      if (state is IsAuthenticated) {
                        return BlocListener<WhatsappNumberBloc,
                            WhatsappNumberStates>(
                          listener: (context, state) {
                            if (state is WhatsappNumberFormSubmitting) {
                              return showDialog(
                                useRootNavigator: false,
                                context: context,
                                builder: (dialogContext) => Material(
                                  type: MaterialType.transparency,
                                  child: Center(
                                    // Aligns the container to center
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                            } else if (state is WhatsappNumberFormSubmitted) {
                              BlocProvider.of<AuthenticationBloc>(context).add(
                                UserUpdated(
                                  user: state.user,
                                  isAlertDialogActive: {
                                    'status': true,
                                    'activeDialog': 2
                                  },
                                ),
                              );
                            }
                          },
                          child: RaisedButton(
                            color: Colors.teal,
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                _formKey.currentState.save();
                                if (_whatsappNumber != null) {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());

                                  dynamic whatsappNumber = {
                                    'whatsapp': _whatsappNumber,
                                  };
                                  BlocProvider.of<WhatsappNumberBloc>(context)
                                    ..add(SaveUserWhatsappNumber(
                                        contactId: state.user.contactId,
                                        data: whatsappNumber));
                                }
                              }
                            },
                            child: Text(
                              'Save',
                              style: TextStyle(color: Colors.white),
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
            ],
          ),
        ),
      ),
    );
  }
}
