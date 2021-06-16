import 'package:windowshoppi/src/app/create_post/create_post_files.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:windowshoppi/src/widget/widget_files.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreatePostActionSheet extends StatefulWidget {
  @override
  _CreatePostActionSheetState createState() => _CreatePostActionSheetState();
}

class _CreatePostActionSheetState extends State<CreatePostActionSheet> {
  // #######################
  // images selection .start
  // #######################

  List<Asset> _images = [];

  Future<void> loadAssets() async {
    List<Asset> resultList = [];
    String error = 'NoError';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 5,
        enableCamera: true,
        selectedAssets: _images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#F44336",
          actionBarTitle: "Choose Photo",
          statusBarColor: '#B73228',
          allViewTitle: "All Photos",
          useDetailsView: false,
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    if (resultList.length != 0) {
      if (error == 'NoError') {
        //close cupertino action sheet
        Navigator.of(context).pop();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreatePostPage(
              imageList: resultList,
            ),
          ),
        );
      } else {
        _toastNotification('Error occurred, please try again.', Colors.red,
            Toast.LENGTH_LONG, ToastGravity.SNACKBAR);
      }
    }
  }

  // #####################
  // images selection .end
  // #####################

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
    return BlocBuilder<AuthenticationBloc, AuthenticationStates>(
      builder: (context, authState) {
        return CupertinoActionSheet(
          actions: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Create New',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      if (authState is AuthenticationLoading)
                        SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                    ],
                  ),
                  Divider(),
                  Card(
                    elevation: 0.0,
                    child: ListTile(
                      onTap: () {
                        if (authState is IsAuthenticated) {
                          // choose image
                          loadAssets();
                        } else if (authState is IsNotAuthenticated) {
                          Navigator.of(context).pop();

                          showDialog(
                            context: context,
                            builder: (context) {
                              return LoginOrRegister();
                            },
                          );
                        } else if (authState is AuthNoInternet) {
                          _toastNotification(
                              'No internet connection',
                              Colors.red,
                              Toast.LENGTH_SHORT,
                              ToastGravity.CENTER);

                          // Retry
                          BlocProvider.of<AuthenticationBloc>(context)
                              .add(CheckUserLoggedInStatus());
                        } else if (authState is AuthenticationError) {
                          _toastNotification(
                              'Error occurred, please try again.',
                              Colors.red,
                              Toast.LENGTH_LONG,
                              ToastGravity.SNACKBAR);

                          // Delete Token
                          BlocProvider.of<AuthenticationBloc>(context)
                              .add(DeleteToken());
                        }
                      },
                      leading: Icon(Icons.grid_on_outlined),
                      title: Text('Feed Post'),
                      trailing: Icon(Icons.keyboard_arrow_right_outlined),
                    ),
                  ),
                  Card(
                    elevation: 0.0,
                    child: Column(
                      children: [
                        ListTile(
                          onTap: () {
                            if (authState is IsAuthenticated) {
                              Navigator.of(context).pop('recommend');
                            } else if (authState is IsNotAuthenticated) {
                              Navigator.of(context).pop();

                              showDialog(
                                context: context,
                                builder: (context) {
                                  return LoginOrRegister();
                                },
                              );
                            } else if (authState is AuthNoInternet) {
                              _toastNotification(
                                  'No internet connection',
                                  Colors.red,
                                  Toast.LENGTH_SHORT,
                                  ToastGravity.CENTER);

                              // Retry
                              BlocProvider.of<AuthenticationBloc>(context)
                                  .add(CheckUserLoggedInStatus());
                            } else if (authState is AuthenticationError) {
                              _toastNotification(
                                  'Error occurred, please try again.',
                                  Colors.red,
                                  Toast.LENGTH_LONG,
                                  ToastGravity.SNACKBAR);

                              // Delete Token
                              BlocProvider.of<AuthenticationBloc>(context)
                                  .add(DeleteToken());
                            }
                          },
                          leading: Icon(Icons.recommend),
                          title: Text('Recommendation'),
                          trailing: Icon(Icons.keyboard_arrow_right_outlined),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(12.0, 0, 12.0, 5.0),
                          child: Text(
                            'Recommend the business around you, or the product you like, or the places to visit in your city and beyond.',
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
