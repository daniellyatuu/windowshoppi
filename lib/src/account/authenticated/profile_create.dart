import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProfileCreate extends StatefulWidget {
  final List<Asset> imageList;
  ProfileCreate({@required this.imageList});

  @override
  _ProfileCreateState createState() => _ProfileCreateState();
}

class _ProfileCreateState extends State<ProfileCreate> {
  final _profileFormKey = GlobalKey<FormState>();

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

  @override
  Widget build(BuildContext context) {
    var image = widget.imageList[0];
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile photo'),
      ),
      body: Center(
        child: Form(
          key: _profileFormKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: AssetThumb(
                    asset: image,
                    width: 150,
                    height: 150,
                    spinner: Center(
                      child: SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                BlocBuilder<AuthenticationBloc, AuthenticationStates>(
                  builder: (context, state) {
                    if (state is IsAuthenticated) {
                      return BlocListener<CreateProfileBloc,
                          CreateProfileStates>(
                        listener: (context, state) {
                          if (state is CreateProfileSubmitting) {
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
                              ),
                            );
                          } else if (state is CreateProfileNoInternet) {
                            Navigator.of(context, rootNavigator: true).pop();
                            _toastNotification(
                                'No internet connection',
                                Colors.red,
                                Toast.LENGTH_SHORT,
                                ToastGravity.CENTER);
                          } else if (state is CreateProfileError) {
                            Navigator.of(context, rootNavigator: true).pop();
                            _toastNotification(
                                'Error occurred, please try again',
                                Colors.red,
                                Toast.LENGTH_LONG,
                                ToastGravity.SNACKBAR);
                          } else if (state is CreateProfileSuccess) {
                            Navigator.of(context, rootNavigator: true).pop();

                            BlocProvider.of<AuthenticationBloc>(context).add(
                              UserUpdated(
                                user: state.user,
                                isAlertDialogActive: {'status': false},
                              ),
                            );

                            Navigator.of(context).pop();
                          }
                        },
                        child: OutlineButton(
                          splashColor: Colors.red,
                          onPressed: () {
                            BlocProvider.of<CreateProfileBloc>(context)
                              ..add(SaveProfilePicture(
                                accountId: state.user.accountId,
                                contactId: state.user.contactId,
                                picture: image,
                              ));
                          },
                          child: Text('SAVE PROFILE'),
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
        ),
      ),
    );
  }
}
