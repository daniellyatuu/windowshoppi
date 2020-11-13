// import 'package:flutter/material.dart';
//
// class Login extends StatefulWidget {
//   @override
//   _LoginState createState() => _LoginState();
// }
//
// class _LoginState extends State<Login> {
//   Widget _divider() {
//     return SizedBox(
//       height: 20.0,
//     );
//   }
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
//               if (value.isEmpty) {
//                 return 'username is required';
//               } else if (value.length < 5) {
//                 return 'username must be greater than 5 character long';
//               } else {
//                 var data = value.trim();
//                 if (data.contains(' ')) {
//                   return 'space between username is not required';
//                 }
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
//             onSaved: (value) => print(value),
//           ),
//         ),
//         // Visibility(
//         //   visible: _isUserExists ? true : false,
//         //   child: Padding(
//         //     padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
//         //     child: Text(
//         //       'username already exists',
//         //       style: TextStyle(color: Colors.red[400], fontSize: 12.0),
//         //     ),
//         //   ),
//         // ),
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
//             // obscureText: _obscureText,
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
//
//             validator: (value) {
//               if (value.isEmpty) {
//                 return 'password is required';
//               } else if (value.length < 4) {
//                 return 'password must be greater than 4 character long';
//               }
//               return null;
//             },
//             onSaved: (value) => print(value),
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
//   Widget _buildForgotPasswordBtn() {
//     return Align(
//       alignment: Alignment.topRight,
//       child: FlatButton(
//         onPressed: () {
//           // Navigator.push(
//           //   context,
//           //   FadeRoute(
//           //     widget: DiscoverAccount(),
//           //   ),
//           // );
//         },
//         child: Text(
//           'Forgot Password?',
//           // style: kLabelStyle,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildLoginBtn() {
//     return Container(
//       width: double.infinity,
//       child: AbsorbPointer(
//         absorbing: false,
//         // absorbing: _isSubmitting ? true : false,
//         child: OutlineButton(
//           splashColor: Colors.red,
//           onPressed: () {
//             print('submit');
//           },
//           child: Text('LOGIN'),
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Form(
//         // key: _loginFormKey,
//         child: ListView(
//           shrinkWrap: true,
//           physics: BouncingScrollPhysics(),
//           children: <Widget>[
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: 15.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Icon(
//                     Icons.account_circle,
//                     color: Colors.grey[350],
//                     size: 90,
//                   ),
//                   _divider(),
//                   Text(
//                     'WINDOWSHOPPI',
//                     style: Theme.of(context).textTheme.headline6,
//                   ),
//                   Text(
//                     'Sign in with your account',
//                     style: TextStyle(
//                       fontSize: 12.0,
//                       color: Colors.grey,
//                     ),
//                   ),
//                   _divider(),
//                   // _buildLogoutAlertWidget(),
//                   // _buildNotificationWidget(),
//                   _buildUsernameTF(),
//                   _divider(),
//                   _buildPasswordTF(),
//                   _buildForgotPasswordBtn(),
//                   _buildLoginBtn(),
// //                          _buildSignWithText(),
// //                          _buildSocialBtnRow(),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
