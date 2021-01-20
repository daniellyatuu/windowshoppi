import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class ProfileCreate extends StatefulWidget {
  @override
  _ProfileCreateState createState() => _ProfileCreateState();
}

class _ProfileCreateState extends State<ProfileCreate> {
  final _profileFormKey = GlobalKey<FormState>();

  void _notification(String txt, Color bgColor, Color btnColor) {
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
    return BlocBuilder<ImageSelectionBloc, ImageSelectionStates>(
      builder: (context, state) {
        if (state is ImageSelected) {
          var image = state.resultList[0];
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () => BlocProvider.of<ImageSelectionBloc>(context)
                  ..add(CheckImage()),
                icon: Icon(Icons.clear),
              ),
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
                                              child:
                                                  CircularProgressIndicator(),
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
                                } else if (state is CreateProfileError) {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                  _notification(
                                      'Error occurred, please try again.',
                                      Colors.red,
                                      Colors.white);
                                } else if (state is CreateProfileSuccess) {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();

                                  BlocProvider.of<AuthenticationBloc>(context)
                                      .add(
                                    UserUpdated(
                                      user: state.user,
                                      isAlertDialogActive: {'status': false},
                                    ),
                                  );

                                  // remove selected image
                                  BlocProvider.of<ImageSelectionBloc>(context)
                                    ..add(CheckImage());
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
          // if (state.imageUsedFor == 'post') {}
        } else {
          return Container();
        }
      },
    );
  }
}
