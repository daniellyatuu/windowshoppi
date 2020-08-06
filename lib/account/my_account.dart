import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:windowshoppi/models/global.dart';
import 'package:windowshoppi/models/local_storage_keys.dart';
import 'package:windowshoppi/routes/fade_transition.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:windowshoppi/account/account_top_section.dart';
import 'package:windowshoppi/explore/post_section.dart';
import 'package:windowshoppi/products/details/details.dart';
import 'package:windowshoppi/explore/post_details.dart';
import 'my_account_bottom_section.dart';
import 'package:flutter/rendering.dart';
import 'dart:async';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:http/http.dart' as http;

class MyAccount extends StatefulWidget {
  final bool fromLogging;
  final Function(bool) isLoginStatus;
  final Function(bool) userLogoutSuccessFully;
  MyAccount(
      {@required this.isLoginStatus,
      @required this.userLogoutSuccessFully,
      this.fromLogging});
  @override
  _MyAccountState createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount>
    with AutomaticKeepAliveClientMixin<MyAccount> {
  bool _isPostBtnVisible = true, isLoading = true;

  final _postFormKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String postCaptionText;

  String name = '',
      location = '',
      userPhoneNumber = '',
      userWhatsappNumber = '',
      businessBio = '',
      businessProfilePhoto = '',
      userEmailAddress = '';

  // #######################
  // images selection .start
  // #######################

  List<Asset> _images = List<Asset>();
  String _error = 'NoError';

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'NoError';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 10,
        enableCamera: true,
        selectedAssets: _images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#008080",
          actionBarTitle: "Choose Photo",
          statusBarColor: '#006868',
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

    setState(() {
      _images = resultList;
      _error = error;
    });

    // check error if exist
    if (_error == 'NoError') {
      setState(() {
        _isPostBtnVisible = true;
      });
    } else {
      _isPostBtnVisible = false;
    }
  }

  void clearImage() {
    setState(() {
      _images = List<Asset>();
    });
  }

//  Widget buildGridView() {
//    return GridView.count(
//      crossAxisCount: 3,
//      children: List.generate(_images.length, (index) {
//        Asset asset = _images[index];
//        return AssetThumb(
//          asset: asset,
//          width: 300,
//          height: 300,
//        );
//      }),
//    );
//  }

  Widget _postCaption() {
    return Row(
      children: <Widget>[
        CircleAvatar(
          radius: 20.0,
          backgroundColor: Colors.grey,
          backgroundImage: NetworkImage(
              'https://images.unsplash.com/photo-1518806118471-f28b20a1d79d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80'),
        ),
        SizedBox(width: 10.0),
        Expanded(
          child: TextFormField(
            maxLines: null,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              hintText: 'Write Caption...',
              border: InputBorder.none,
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'caption is required';
              }
              return null;
            },
            onSaved: (value) => postCaptionText = value,
          ),
        ),
      ],
    );
  }

  // #####################
  // images selection .end
  // #####################

  String view = "grid"; // default view

  Widget _accountHeader() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          _topAccountSection(),
          _accountDetails(),
          if (userEmailAddress != null)
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(top: 5.0),
              child: Text(
                userEmailAddress,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          if (businessBio != null)
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(top: 5.0),
              child: Text(
                businessBio,
                textAlign: TextAlign.justify,
              ),
            ),
//          Text('$file'),
          _editProfileBtn(),
        ],
      ),
    );
  }

  Widget _topAccountSection() {
    return Row(
      children: <Widget>[
        businessProfilePhoto == ''
            ? CircleAvatar(
                radius: 35.0,
                backgroundColor: Colors.grey[300],
                child: Icon(Icons.store, size: 30),
              )
            : CircleAvatar(
                radius: 35.0,
                backgroundColor: Colors.grey[300],
                backgroundImage: NetworkImage(
                    'https://images.unsplash.com/photo-1518806118471-f28b20a1d79d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80'),
              ),
        Expanded(
          child: ListTile(
            title: Text(name),
            subtitle: Text(location),
            trailing: Column(
              children: <Widget>[
                _buildStatColumn('POST', 12),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _accountDetails() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 4.0),
      margin: EdgeInsets.only(top: 5.0),
      decoration: BoxDecoration(
//        color: Color(0xFFE5E5E5),
//        borderRadius: BorderRadius.circular(2),
          ),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          if (userPhoneNumber != null)
            Expanded(
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.blue,
                    radius: 15.0,
                    child: FaIcon(
                      FontAwesomeIcons.phone,
                      size: 15.0,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  Expanded(
                    child: Text(
                      userPhoneNumber,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Color(0xFF06B862),
                  radius: 15.0,
                  child: FaIcon(
                    FontAwesomeIcons.whatsapp,
                    size: 15.0,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 8.0,
                ),
                userWhatsappNumber != null
                    ? Expanded(
                        child: Text(
                          userWhatsappNumber,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )
                    : Expanded(
                        child: Text(
                          'not specified',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String label, int number) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          number.toString(),
          style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4.0),
          child: Text(
            label,
            style: TextStyle(
                color: Colors.grey,
                fontSize: 15.0,
                fontWeight: FontWeight.w400),
          ),
        ),
      ],
    );
  }

  Widget _editProfileBtn() {
    return Container(
      width: double.infinity,
      child: OutlineButton(
        onPressed: () {},
//      padding: EdgeIn,
        child: Text('edit profile'),
      ),
    );
//    return Container(
//      width: double.infinity,
//      child: FlatButton(
//        padding: EdgeInsets.all(0.0),
//        onPressed: () {
//          print('edit profile');
//        },
//        child: Container(
//          padding: EdgeInsets.symmetric(vertical: 5.0),
//          decoration: BoxDecoration(
//            border: Border.all(color: Colors.grey),
//            borderRadius: BorderRadius.circular(5.0),
//          ),
//          alignment: Alignment.center,
//          child: Text(
//            'edit profile',
//            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//          ),
//        ),
//      ),
//    );
  }

  Widget _buildImageViewButtonBar() {
    Color isActiveButtonColor(String viewName) {
      if (view == viewName) {
        return Colors.blueAccent;
      } else {
        return Colors.black26;
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
          icon: Icon(
            Icons.grid_on,
            color: isActiveButtonColor("grid"),
          ),
          onPressed: () {
            changeView("grid");
          },
        ),
        IconButton(
          icon: Icon(
            Icons.list,
            color: isActiveButtonColor("feed"),
          ),
          onPressed: () {
            changeView("feed");
          },
        ),
      ],
    );
  }

  changeView(String viewName) {
    setState(() {
      view = viewName;
    });
  }

  List<String> _posts = [
    'https://lh5.googleusercontent.com/proxy/XuQ0Dc8ews6V2G3iQqp8oYWupJdK3s1WxJ_n1cXFaDGmpMzIbceiEgo7i1GqFoz_Ppf4MCe4uWQSXX431u3MgHzlpdUMRoU',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQUTcsi010F5zBOmMN24rnbstMgM3rh8u_dWrWQXPLu_UXuUB1E&s',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQIbNH5TdL5-CyiwdqglmGeKdHgIl8-BcFFTHMWUIVis5-q0I2T&s',
    'https://api.time.com/wp-content/uploads/2018/11/sweetfoam-sustainable-product.jpg?quality=85',
    'https://lh3.googleusercontent.com/kcuyhFJT68FzCgfH-Ow8DdUiL1xgUp6rdAHpSDqF3Eg8j4HQ3O9ANxsyy_EpiTBvhXnLvNvOmI1ygIONDgIV_4xHYyxyd5y5f0EHAQ=w262-l90-sg-rj',
    'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/iphone11-red-select-2019?wid=940&hei=1112&fmt=png-alpha&qlt=80&.v=1566956144763',
    'https://static.livebooks.com/abc61dbc6e9c403b917975eb48d2d97d/i/f2c81f819c994f5eb2312f9948520c2a/1/4SoifmQp7LJ6yDtMuFY2x/Swan-Optic-22089.jpg',
    'https://www.apple.com/v/product-red/o/images/meta/og__dbjwy50zuc02.png?202005090509',
    'https://api.time.com/wp-content/uploads/2018/11/sweetfoam-sustainable-product.jpg?quality=85',
    'https://in.canon/media/image/2018/05/03/642e7bbeae5741e3b872e082626c0151_eos6d-mkii-ef-24-70m-l.png',
  ];

  Widget _buildUserPosts() {
    if (view == 'grid') {
      return GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemCount: _posts.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
//              Navigator.push(
//                context,
//                FadeRoute(
//                  widget: Details(imageUrl: _posts[index]),
//                ),
//              );
            },
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: _posts[index],
              fit: BoxFit.cover,
            ),
          );
        },
      );
    } else if (view == 'feed') {
      return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: _posts.length,
        itemBuilder: (context, index) {
          return listPost(_posts[index]);
        },
      );
    }
    return null;
  }

  Widget listPost(String imgUrl) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          AccountTopSection(),
//          PostSection(imageUrl: imgUrl),
          MyAccountBottomSection(postImage: imgUrl),
          PostDetails(),
        ],
      ),
    );
  }

  void _getUserData() async {
    setState(() {
      isLoading = true;
    });

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var _businessName = localStorage.getString(businessName);
    var _businessLocation = localStorage.getString(businessLocation);
    var _bio = localStorage.getString(bio);
    var _whatsapp = localStorage.getString(whatsapp);
    var _callNumber = localStorage.getString(callNumber);
    var _profileImage = localStorage.getString(profileImage);
    var _userEmailAddress = localStorage.getString(userMail);

    setState(() {
      name = _businessName;
      location = _businessLocation;
      userPhoneNumber = _callNumber;
      userWhatsappNumber = _whatsapp;
      businessBio = _bio;
      businessProfilePhoto = _profileImage;
      userEmailAddress = _userEmailAddress;
      isLoading = false;
    });
  }

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scaffoldKey.currentState.showSnackBar(snackBar);
    });
  }

  @override
  void initState() {
    super.initState();
    _getUserData();

    if (widget.fromLogging == true) {
      _notification('Welcome to windowshoppi', Colors.black, Colors.red);
    }
  }

  Future _uploadPost(caption, receiveImages) async {
    Uri uri = Uri.parse(CREATE_POST);

// create multipart request
    MultipartRequest request = http.MultipartRequest("POST", uri);

    var i = 0;
    for (var imageFile in receiveImages) {
      i += 1;
      String fileName = 'image_' +
          i.toString() +
          '_' +
          DateTime.now().millisecondsSinceEpoch.toString() +
          '.jpg';

      ByteData byteData = await imageFile.getByteData(quality: 60);

      List<int> imageData = byteData.buffer.asUint8List();

      MultipartFile multipartFile = MultipartFile.fromBytes(
        'filename',
        imageData,
        filename: fileName,
        // contentType: MediaType("image", "jpg"),
      );
      request.files.add(multipartFile);
    }

    // add file to multipart
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString(userToken);
    var businessAccountId = localStorage.getString(businessId);

    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Token $token",
    };

    //add headers
    request.headers.addAll(headers);

    request.fields['bussiness'] = businessAccountId;
    request.fields['caption'] = caption;

    // send
    var response = await request.send();

    // listen for response
    response.stream.transform(utf8.decoder).listen((result) {
      print(result);
      if (result == '"success"') {
        clearImage(); // remove images
        _notification('Post created successfully', Colors.black, Colors.red);
      }
    });
  }

//  void _notification(String txt, Color color) {
//    final snackBar = SnackBar(
//      content: Text(txt),
//      backgroundColor: color,
//      action: SnackBarAction(
//        label: 'Hide',
//        onPressed: () {
//          Scaffold.of(context).hideCurrentSnackBar();
//        },
//      ),
//    );
//    Scaffold.of(context).showSnackBar(snackBar);
//  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // reloads state when opened again

    return _images.length == 0
        ? Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              title: Text('my account'),
            ),
            endDrawer: Drawer(
              child: ListView(
                children: <Widget>[
                  GestureDetector(
                    onTap: () async {
                      SharedPreferences localStorage =
                          await SharedPreferences.getInstance();
                      localStorage.remove(userToken);
                      localStorage.remove(businessId);
                      localStorage.remove(businessName);
                      localStorage.remove(businessLocation);
                      localStorage.remove(bio);
                      localStorage.remove(whatsapp);
                      localStorage.remove(callNumber);
                      localStorage.remove(profileImage);
                      localStorage.remove(userMail);
                      widget.isLoginStatus(false);
                      widget.userLogoutSuccessFully(true);
                    },
                    child: Card(
                      color: Colors.teal,
                      child: ListTile(
                        title: Text(
                          'LOGOUT',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            body: isLoading
                ? Center(
                    child: SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(strokeWidth: 2.0),
                    ),
                  )
                : ListView(
                    children: <Widget>[
                      _accountHeader(),
                      Divider(height: 0.0),
                      _buildImageViewButtonBar(),
                      Divider(height: 0.0),
                      _buildUserPosts(),
                    ],
                  ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.red,
              onPressed: loadAssets,
              tooltip: 'post a photo',
              child: Icon(Icons.add_box),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text('new post'),
              leading: IconButton(
                onPressed: clearImage,
                icon: Icon(Icons.clear),
              ),
              actions: <Widget>[
                Visibility(
                  visible: _isPostBtnVisible,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: GestureDetector(
                      onTap: () async {
                        if (_postFormKey.currentState.validate()) {
                          _postFormKey.currentState.save();

                          print('start');
                          await showDialog(
                            barrierDismissible: true,
                            context: context,
                            builder: (context) {
                              var res = _uploadPost(postCaptionText, _images);
                              res.then(
                                (value) => {
                                  print(value),
                                  Navigator.of(context).pop(),
                                },
                              );
                              return AlertDialog(
                                content: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 15,
                                      width: 15,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 1.0),
                                    ),
                                    SizedBox(width: 8.0),
                                    Text(
                                      'please wait...',
                                      style: TextStyle(
                                        letterSpacing: 1.5,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.0,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                          print('finish');
                        }
                      },
                      child: Row(
                        children: <Widget>[
                          Text('POST ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18)),
                          Icon(Icons.send, size: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            body: Center(
              child: _error == 'NoError'
                  ? Form(
                      key: _postFormKey,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            _postCaption(),
                            Divider(),
                            Expanded(
                              child: GridView.count(
                                physics: BouncingScrollPhysics(),
                                crossAxisCount: 3,
                                children: List.generate(
                                  _images.length,
                                  (index) {
                                    Asset asset = _images[index];
                                    return Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: AssetThumb(
                                        asset: asset,
                                        width: 300,
                                        height: 300,
                                        spinner: Center(
                                          child: SizedBox(
                                            width: 22,
                                            height: 22,
                                            child: CircularProgressIndicator(
                                                strokeWidth: 2),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: OutlineButton(
                                onPressed: loadAssets,
                                child: Text('add more photos'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Text(_error),
            ),
          );
  }

  // ensures state is kept when switching pages
  @override
  bool get wantKeepAlive => true;
}
