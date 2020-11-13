// import 'package:animations/animations.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:windowshoppi/auth/LoginPage.dart';
// import 'package:windowshoppi/auth/RegisterPage.dart';
// import 'package:windowshoppi/bloc/authentication/AuthenticationBloc.dart';
// import 'package:windowshoppi/bloc/authentication/AuthenticationStates.dart';
//
// class Account extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<AuthenticationBloc, AuthenticationStates>(
//       listener: (context, AuthenticationStates state) {
//         print(state);
//       },
//       builder: (context, AuthenticationStates state) {
//         if (state is IsNotAuthenticated) {
//           return LoginRegister();
//         } else {
//           return Center(
//             child: Text(
//               'User was logged In',
//               style: Theme.of(context).textTheme.headline5,
//             ),
//           );
//         }
//       },
//     );
//   }
// }
//
// class LoginRegister extends StatefulWidget {
//   @override
//   _LoginRegisterState createState() => _LoginRegisterState();
// }
//
// class _LoginRegisterState extends State<LoginRegister> {
//   bool _registerIsActive = true;
//
//   void _togglePage() {
//     setState(() {
//       _registerIsActive = !_registerIsActive;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           children: <Widget>[
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 15.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: <Widget>[
//                   Expanded(
//                     child: Padding(
//                       padding: const EdgeInsets.only(right: 2.0),
//                       child: RaisedButton(
//                         onPressed: _registerIsActive ? null : _togglePage,
//                         // onPressed: () => _page == 'register'
//                         //     ? print('here')
//                         //     : _togglePage('register'),
//                         textColor: Theme.of(context).colorScheme.onPrimary,
//                         color: Theme.of(context).colorScheme.primary,
//                         child: const Text('REGISTER'),
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: Padding(
//                       padding: const EdgeInsets.only(left: 2.0),
//                       child: RaisedButton(
//                         onPressed: _registerIsActive ? _togglePage : null,
//                         // onPressed: () =>
//                         //     _page == 'register' ? _togglePage('login') : null,
//                         color: Theme.of(context).colorScheme.primary,
//                         textColor: Theme.of(context).colorScheme.onPrimary,
//                         child: const Text('LOGIN'),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const Divider(thickness: 2.0),
//             Expanded(
//               child: PageTransitionSwitcher(
//                 duration: const Duration(milliseconds: 300),
//                 reverse: _registerIsActive,
//                 transitionBuilder: (
//                   Widget child,
//                   Animation<double> animation,
//                   Animation<double> secondaryAnimation,
//                 ) {
//                   return SharedAxisTransition(
//                     child: child,
//                     animation: animation,
//                     secondaryAnimation: secondaryAnimation,
//                     transitionType: SharedAxisTransitionType.horizontal,
//                   );
//                 },
//                 child: _registerIsActive ? Register() : Login(),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
