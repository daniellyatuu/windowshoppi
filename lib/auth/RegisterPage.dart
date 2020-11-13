// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:windowshoppi/bloc/bloc.dart';
// import 'package:windowshoppi/models/models.dart';
// import 'package:windowshoppi/repository/repository.dart';
// import 'package:windowshoppi/utilities/constants.dart';
// import 'package:http/http.dart' as http;
//
// class Register extends StatelessWidget {
//   final CountryRepository countryRepository = CountryRepository(
//     countryAPIClient: CountryAPIClient(
//       httpClient: http.Client(),
//     ),
//   );
//
//   final RegistrationRepository registrationRepository = RegistrationRepository(
//     registrationAPIClient: RegistrationAPIClient(),
//   );
//
//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider<CountryBloc>(
//           create: (context) => CountryBloc(countryRepository: countryRepository)
//             ..add(FetchCountry()),
//         ),
//         BlocProvider<RegistrationBloc>(
//           create: (context) =>
//               RegistrationBloc(registrationRepository: registrationRepository),
//         ),
//       ],
//       child: RegisterForm(),
//     );
//   }
// }
//
// class RegisterForm extends StatefulWidget {
//   @override
//   _RegisterFormState createState() => _RegisterFormState();
// }
//
// class _RegisterFormState extends State<RegisterForm> {
//   var country = new List<Country>();
//
//   final _formKey = GlobalKey<FormState>();
//
//   // form data
//   String _accountName,
//       _phoneNumber,
//       _userName,
//       _passWord,
//       _emailAddress,
//       _country;
//
//   Widget _divider() {
//     return SizedBox(
//       height: 20.0,
//     );
//   }
//
//   Widget _buildAccountNameTF() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         TextFormField(
//           decoration: InputDecoration(
//             prefixIcon: Icon(Icons.account_circle, color: Colors.black54),
//             labelText: 'Account name*',
//             border: OutlineInputBorder(),
//             isDense: true,
//           ),
//           validator: (value) {
//             if (value.isEmpty) {
//               return 'account name is required';
//             }
//             return null;
//           },
//           onSaved: (value) => _accountName = value,
//         ),
//       ],
//     );
//   }
//
//   Widget _buildPhoneNumberTF() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         Container(
//           padding: EdgeInsets.all(0.0),
//           alignment: Alignment.centerLeft,
//           child: TextFormField(
//             keyboardType: TextInputType.phone,
//             decoration: InputDecoration(
//               prefixIcon: Icon(Icons.phone, color: Colors.black54),
//               labelText: 'Phone number*',
//               border: OutlineInputBorder(),
//               isDense: true,
//             ),
//             validator: (value) {
//               String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
//               RegExp regExp = new RegExp(pattern);
//               if (value.isEmpty) {
//                 return 'phone number is required';
//               } else if (!regExp.hasMatch(value)) {
//                 return 'Please enter valid phone number';
//               }
//               return null;
//             },
//             onSaved: (value) => _phoneNumber = value,
//           ),
//         ),
//       ],
//     );
//   }
//
//   bool _isUserExists = false;
//
//   Widget _buildUsernameTF() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         Container(
//           padding: EdgeInsets.all(0.0),
//           alignment: Alignment.centerLeft,
//           child: TextFormField(
//             decoration: InputDecoration(
//               prefixIcon: Icon(Icons.alternate_email, color: Colors.black54),
//               labelText: 'Username*',
//               border: OutlineInputBorder(),
//               isDense: true,
//             ),
//             validator: (value) {
//               var data = value.trim();
//               if (data.isEmpty) {
//                 return 'username is required';
//               } else if (data.contains(' ')) {
//                 return 'space between username is not required';
//               } else if (data.contains('-')) {
//                 return 'dash is not required in username';
//               } else if (data.length < 5) {
//                 return 'username must be greater than 5 character long';
//               }
//               return null;
//             },
// //             onChanged: (value) async {
// //               setState(() {
// //                 _isUsernameLoading = true;
// //                 _isUserExists = false;
// //               });
// //               // check validation .start
// //               var data = value.trim();
// //               if (data.length >= 5 && !data.contains(' ')) {
// //                 var usernameData = {
// //                   'username': data,
// //                 };
// //                 var res = await _checkUsername(usernameData);
// //
// //                 if (res['user_exists'] == true) {
// //                   _isUsernameGood = false;
// //                   _isUserExists = true;
// //                 } else {
// //                   _isUserExists = false;
// //                   _isUsernameGood = true;
// //                 }
// //               } else if (value.length == 0) {
// //                 _isUsernameGood = false;
// //                 _isUserExists = false;
// //               } else {
// //                 _isUsernameGood = false;
// //               }
// //
// //               setState(() {
// //                 _isUsernameLoading = false;
// //               });
// //
// // //              if (value.length > 5) {
// // //                setState(() {
// // //                  _isUsernameGood = true;
// // //                });
// // //              } else if (value.length == 0) {
// // //                _isUsernameLoading = false;
// // //                _isUsernameGood = false;
// // //              } else {
// // //                setState(() {
// // //                  _isUsernameGood = false;
// // //                });
// // //              }
// //             },
//             onSaved: (value) => _userName = value,
//           ),
//         ),
//         Visibility(
//           visible: _isUserExists ? true : false,
//           child: Padding(
//             padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
//             child: Text(
//               'username already exists',
//               style: TextStyle(color: Colors.red[400], fontSize: 12.0),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   // Initially password is obscure
//   bool _obscureText = true;
//
//   Widget _buildPasswordTF() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         Container(
//           padding: EdgeInsets.all(0.0),
//           alignment: Alignment.centerLeft,
//           child: TextFormField(
//             obscureText: _obscureText,
//             decoration: InputDecoration(
//               labelText: 'Password*',
//               prefixIcon: Icon(
//                 Icons.lock_outline,
//                 color: Colors.black54,
//               ),
//               suffixIcon: IconButton(
//                 onPressed: _toggle,
//                 icon: _obscureText
//                     ? Icon(
//                         Icons.visibility_off,
//                         color: Colors.grey,
//                       )
//                     : Icon(
//                         Icons.visibility,
//                         color: Colors.grey[700],
//                       ),
//               ),
//               contentPadding: EdgeInsets.symmetric(
//                 vertical: 0.0,
//                 horizontal: 10.0,
//               ),
//               border: OutlineInputBorder(),
//               isDense: true,
//             ),
//             validator: (value) {
//               if (value.isEmpty) {
//                 return 'password is required';
//               } else if (value.length < 4) {
//                 return 'password must be greater than 4 character long';
//               }
//               return null;
//             },
//             onSaved: (value) => _passWord = value,
//           ),
//         ),
//       ],
//     );
//   }
//
//   void _toggle() {
//     setState(() {
//       _obscureText = !_obscureText;
//     });
//   }
//
//   Widget _buildEmailTF() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         Container(
//           padding: EdgeInsets.all(0.0),
//           alignment: Alignment.centerLeft,
//           child: TextFormField(
//             keyboardType: TextInputType.emailAddress,
//             decoration: InputDecoration(
//               labelText: 'Email address',
//               prefixIcon: Icon(
//                 Icons.email,
//                 color: Colors.black54,
//               ),
//               border: OutlineInputBorder(),
//               isDense: true,
//             ),
//             validator: (value) {
//               Pattern pattern =
//                   r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
//               RegExp regExp = new RegExp(pattern);
//
//               if (value.isNotEmpty) {
//                 if (!regExp.hasMatch(value)) {
//                   return 'please enter valid email';
//                 }
//               }
//               return null;
//             },
//             onSaved: (value) => _emailAddress = value,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildSelectCountryDropDown() {
//     return Container(
//       decoration: kBoxDecorationStyle,
//       child: ButtonTheme(
//         alignedDropdown: true,
//         child: DropdownButtonFormField<String>(
//           isExpanded: true,
//           isDense: true,
//           hint: Text('Country*'),
//           // value: _activeCountryId,
//           onChanged: (String newValue) {
//             // setState(() {
//             //   _activeCountryId = newValue;
//             // });
//             FocusScope.of(context).requestFocus(FocusNode());
//           },
//           validator: (value) {
//             if (value == null) {
//               return 'country is required';
//             }
//             return null;
//           },
//           onSaved: (value) => _country = value,
//           decoration: InputDecoration(
//             border: InputBorder.none,
//           ),
//           items: country.map(
//             (Country map) {
//               return DropdownMenuItem<String>(
//                 onTap: () {},
//                 value: map.id.toString(),
//                 child: Row(
//                   children: <Widget>[
//                     SizedBox(
//                       width: 40.0,
//                       child: Image.network('${map.flag}'),
//                     ),
//                     SizedBox(
//                       width: 15.0,
//                     ),
//                     Expanded(
//                       child: Text(map.countryName),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ).toList(),
//         ),
//       ),
//     );
//   }
//
//   // void showAlert(BuildContext context) {
//   //   showDialog(
//   //     context: context,
//   //     builder: (dialogContext) => Material(
//   //       type: MaterialType.transparency,
//   //       child: Center(
//   //         // Aligns the container to center
//   //         child: Column(
//   //           mainAxisAlignment: MainAxisAlignment.center,
//   //           children: [
//   //             GestureDetector(
//   //               onTap: () {
//   //                 Navigator.of(dialogContext).pop();
//   //               },
//   //               child: SizedBox(
//   //                 width: 40,
//   //                 height: 40,
//   //                 child: CircularProgressIndicator(),
//   //               ),
//   //             ),
//   //             SizedBox(
//   //               height: 10.0,
//   //             ),
//   //             Text(
//   //               'Saving..',
//   //               style: TextStyle(
//   //                 color: Colors.white,
//   //                 fontSize: 16.0,
//   //                 fontWeight: FontWeight.bold,
//   //               ),
//   //             ),
//   //           ],
//   //         ),
//   //       ),
//   //     ),
//   //   );
//   // }
//
//   Widget _buildRegisterBtn() {
//     return BlocConsumer<RegistrationBloc, RegistrationStates>(
//       listener: (context, RegistrationStates state) async {
//         print(state);
//         if (state is FormSubmitting) {
//           return showDialog(
//             useRootNavigator: false,
//             context: context,
//             builder: (dialogContext) => Material(
//               type: MaterialType.transparency,
//               child: Center(
//                 // Aligns the container to center
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.of(dialogContext).pop();
//                       },
//                       child: SizedBox(
//                         width: 40,
//                         height: 40,
//                         child: CircularProgressIndicator(),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 10.0,
//                     ),
//                     Text(
//                       'Saving..',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 16.0,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         } else if (state is UserExist) {
//           await Future.delayed(Duration(milliseconds: 500), () {
//             Navigator.of(context).pop();
//           });
//           setState(() {
//             _isUserExists = true;
//           });
//         } else if (state is FormSubmitted) {
//           await Future.delayed(Duration(milliseconds: 500), () {
//             Navigator.of(context).pop();
//           });
//         }
//       },
//       builder: (context, RegistrationStates state) {
//         return Container(
//           width: double.infinity,
//           child: AbsorbPointer(
//             absorbing: false,
//             // absorbing: _isSubmitting ? true : false,
//             child: OutlineButton(
//               splashColor: Colors.red,
//               onPressed: () {
//                 FocusScope.of(context).requestFocus(FocusNode());
//
//                 if (_formKey.currentState.validate()) {
//                   _formKey.currentState.save();
//                   dynamic userData = {
//                     'group': 3,
//                     'name': _accountName,
//                     'call': _phoneNumber,
//                     'username': _userName,
//                     'password': _passWord,
//                     'email': _emailAddress,
//                     'country': _country,
//                   };
//
//                   BlocProvider.of<RegistrationBloc>(context)
//                       .add(SaveUserData(data: userData));
//                 }
//               },
//               child: Text('REGISTER'),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<CountryBloc, CountryStates>(
//       listener: (context, CountryStates state) {
//         print(state);
//         if (state is CountryLoaded) {
//           country = state.country;
//         }
//       },
//       builder: (context, CountryStates state) {
//         if (state is CountryLoading) {
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         } else if (state is CountryError) {
//           return Center(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   Icons.error,
//                   color: Colors.red,
//                 ),
//                 Text(
//                   ' Error Occurred',
//                   style: TextStyle(
//                       color: Colors.red,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16.0),
//                 ),
//               ],
//             ),
//           );
//         } else if (state is CountryLoaded) {
//           return Center(
//             child: ListView(
//               shrinkWrap: true,
//               physics: BouncingScrollPhysics(),
//               children: [
//                 Container(
//                   padding: EdgeInsets.only(top: 20.0),
//                   alignment: Alignment.center,
//                   child: Text(
//                     'CREATE ACCOUNT',
//                     style: Theme.of(context).textTheme.headline6,
//                   ),
//                 ),
//                 Container(
//                   alignment: Alignment.center,
//                   child: Text(
//                     'Enter your details below',
//                     style: TextStyle(
//                       fontSize: 12.0,
//                       color: Colors.grey,
//                     ),
//                   ),
//                 ),
//                 _divider(),
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 15.0),
//                   child: Form(
//                     key: _formKey,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: <Widget>[
//                         RaisedButton(
//                           onPressed: () =>
//                               BlocProvider.of<AuthenticationBloc>(context)
//                                   .add(CheckUserLoggedInStatus()),
//                           child: Text('AUTH'),
//                         ),
//                         _buildAccountNameTF(),
//                         _divider(),
//                         _buildPhoneNumberTF(),
//                         _divider(),
//                         _buildUsernameTF(),
//                         _divider(),
//                         _buildPasswordTF(),
//                         _divider(),
//                         _buildEmailTF(),
//                         _divider(),
//                         _buildSelectCountryDropDown(),
//                         _divider(),
//                         _buildRegisterBtn(),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }
//         return Text('');
//       },
//     );
//   }
// }
