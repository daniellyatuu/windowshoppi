import 'package:windowshoppi/src/utilities/expandable_text.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:windowshoppi/src/account/account_files.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  // #######################
  // images selection .start
  // #######################

  List<Asset> _images = List<Asset>();

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'NoError';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
        enableCamera: true,
        selectedAssets: _images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#F44336",
          actionBarTitle: "Choose Profile Photo",
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
      // close cupertino action sheet
      Navigator.of(context, rootNavigator: true).pop();
      if (error == 'NoError') {
        BlocProvider.of<ImageSelectionBloc>(context)
          ..add(SelectImage(resultList: resultList, imageUsedFor: 'profile'));
      } else {
        BlocProvider.of<ImageSelectionBloc>(context)
          ..add(ImageSelectionError(error: error));
      }
    }
  }

  // #####################
  // images selection .end
  // #####################

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
    return BlocBuilder<AuthenticationBloc, AuthenticationStates>(
      builder: (context, state) {
        if (state is IsAuthenticated) {
          var data = state.user;

          return BlocListener<CreateProfileBloc, CreateProfileStates>(
            listener: (context, state) {
              if (state is RemoveProfileLoading) {
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
                            'Please wait..',
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
              } else if (state is RemoveProfileError) {
                Navigator.of(context, rootNavigator: true).pop();
                Navigator.of(context, rootNavigator: true).pop();
                _notification('Error occurred, please try again.', Colors.red,
                    Colors.white);
              } else if (state is RemoveProfileSuccess) {
                Navigator.of(context, rootNavigator: true).pop();

                BlocProvider.of<AuthenticationBloc>(context).add(
                  UserUpdated(
                    user: state.user,
                    isAlertDialogActive: {'status': false},
                  ),
                );

                Navigator.of(context, rootNavigator: true).pop();
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      showCupertinoModalPopup(
                        context: context,
                        builder: (context) => CupertinoActionSheet(
                          message: Column(
                            children: [
                              Card(
                                color: Colors.teal.withOpacity(0.3),
                                elevation: 0.0,
                                child: ListTile(
                                  onTap: loadAssets,
                                  dense: true,
                                  title: Text('Change profile'),
                                ),
                              ),
                              if (data.profileImage != null)
                                Card(
                                  color: Colors.red.withOpacity(0.3),
                                  elevation: 0.0,
                                  child: ListTile(
                                    onTap: () =>
                                        BlocProvider.of<CreateProfileBloc>(
                                            context)
                                          ..add(RemoveProfile(
                                            accountId: data.accountId,
                                            contactId: data.contactId,
                                          )),
                                    dense: true,
                                    title: Text('Remove profile'),
                                  ),
                                ),
                              Card(
                                color: Colors.grey.withOpacity(0.3),
                                elevation: 0.0,
                                child: ListTile(
                                  onTap: () => Navigator.of(context).pop(),
                                  dense: true,
                                  title: Text('Cancel'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Stack(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 4,
                            height: MediaQuery.of(context).size.width / 4,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              shape: BoxShape.circle,
                            ),
                            child: data.profileImage == null
                                ? FittedBox(
                                    child: Icon(Icons.account_circle,
                                        color: Colors.grey[400]),
                                  )
                                : ClipOval(
                                    child: ExtendedImage.network(
                                      '${data.profileImage}',
                                      cache: true,
                                      loadStateChanged:
                                          (ExtendedImageState state) {
                                        switch (state.extendedImageLoadState) {
                                          case LoadState.loading:
                                            return CupertinoActivityIndicator();
                                            break;

                                          ///if you don't want override completed widget
                                          ///please return null or state.completedWidget
                                          //return null;
                                          //return state.completedWidget;
                                          case LoadState.completed:
                                            return ExtendedRawImage(
                                              fit: BoxFit.cover,
                                              image: state
                                                  .extendedImageInfo?.image,
                                            );
                                            break;
                                          case LoadState.failed:
                                            // _controller.reset();
                                            return GestureDetector(
                                              child: Center(
                                                child: Icon(Icons.refresh),
                                              ),
                                              onTap: () {
                                                state.reLoadImage();
                                              },
                                            );
                                            break;
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                          ),
                          Positioned(
                            bottom: 10.0,
                            right: 0.0,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                color: Colors.black.withOpacity(0.6),
                              ),
                              padding: EdgeInsets.all(5.0),
                              child: Icon(
                                Icons.edit,
                                size: 16.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Text(
                    '${data.accountName}',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  if (data.group == 'vendor')
                    Container(
                      child: Text(
                        ' ${data.businessBio}',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ),
                  if (data.group == 'windowshopper') Divider(),
                  if (data.group == 'vendor')
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: CircleAvatar(
                                  backgroundColor: Colors.blue,
                                  child: FaIcon(
                                    FontAwesomeIcons.phone,
                                    size: 15.0,
                                    color: Colors.white,
                                  ),
                                ),
                                title: Text('${data.call}'),
                                dense: true,
                              ),
                            ),
                            Expanded(
                              child: ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: CircleAvatar(
                                  backgroundColor: Color(0xFF06B862),
                                  child: FaIcon(
                                    FontAwesomeIcons.whatsapp,
                                    size: 18.0,
                                    color: Colors.white,
                                  ),
                                ),
                                title: data.whatsapp != null
                                    ? Text('${data.whatsapp}')
                                    : WhatsappNumberPopUp(),
                                dense: true,
                              ),
                            ),
                          ],
                        ),
                        if (data.email != null)
                          Row(
                            children: [
                              Icon(
                                Icons.email_outlined,
                                size: 16.0,
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  ' ${data.email}',
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ),
                            ],
                          ),
                        if (data.accountBio != null)
                          Container(
                            alignment: Alignment.centerLeft,
                            child: ExpandableText(
                              text: '${data.accountBio}',
                              trimLines: 5,
                              readLess: true,
                            ),
                          ),
                      ],
                    ),
                  if (data.group == 'windowshopper')
                    Column(
                      children: [
                        if (data.email != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 3.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.email_outlined,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(
                                      text: ' ${data.email}',
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: ' (private)',
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 3.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.call,
                                size: 16,
                                color: Colors.grey,
                              ),
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    text: ' ${data.call}',
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: ' (private)',
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (data.accountBio != null)
                          Container(
                            alignment: Alignment.centerLeft,
                            child: ExpandableText(
                              text: '${data.accountBio}',
                              trimLines: 3,
                              readLess: true,
                            ),
                          ),
                      ],
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: OutlineButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => data.group ==
                                        'windowshopper'
                                    ? UpdateProfileInit()
                                    : VendorUpdateProfileInit(
                                        callIsoCode: data.callIsoCode,
                                        whatsappIsoCode: data.whatsappIsoCode,
                                      ),
                              ),
                            );
                          },
                          child: Text('edit profile'),
                        ),
                      ),
                      if (data.group == 'windowshopper')
                        SizedBox(
                          width: 8.0,
                        ),
                      if (data.group == 'windowshopper')
                        Expanded(
                          flex: 2,
                          child: RaisedButton(
                            color: Colors.teal,
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => IntroScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'switch to business account',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('change profile photo'),
      ),
    );
  }
}
