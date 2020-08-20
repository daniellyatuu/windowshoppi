import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:windowshoppi/edit_profile/edit_profile.dart';
import 'package:windowshoppi/explore/ExpandableText.dart';
import 'package:windowshoppi/models/global.dart';
import 'package:windowshoppi/models/local_storage_keys.dart';
import 'package:windowshoppi/models/product.dart';
import 'package:windowshoppi/products/details/bottom_section.dart';
import 'package:windowshoppi/routes/fade_transition.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:windowshoppi/account/account_top_section.dart';
import 'package:windowshoppi/explore/post_section.dart';
import 'package:windowshoppi/products/details/details.dart';
import 'package:windowshoppi/explore/post_details.dart';
import 'package:windowshoppi/widgets/loader.dart';
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
  final _postFormKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController _scrollController = ScrollController();

  int activePhoto = 0;

  var data = new List<Product>();
  String newUrl, nextUrl;
  bool _isPostBtnVisible = true, isLoading = true;
  bool removeListData, _isGettingServerData, firstLoading;
  bool _isInitialLoading = true;
  int allProducts = 0;
  int loggedInBussinessId = 0;

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

  Widget _postCaption() {
    return Row(
      children: <Widget>[
        businessProfilePhoto == ''
            ? CircleAvatar(
                radius: 20.0,
                backgroundColor: Colors.grey[300],
                child: Icon(Icons.store, size: 20, color: Colors.grey),
              )
            : CircleAvatar(
                radius: 35.0,
                backgroundColor: Colors.grey[300],
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
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ExpandableText(
                text: businessBio,
                trimLines: 4,
                readLess: true,
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
                child: Icon(Icons.store, size: 30, color: Colors.grey),
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
                _isInitialLoading == false
                    ? _buildStatColumn('POST', allProducts)
                    : Text(''),
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
        onPressed: () {
          Navigator.push(
            context,
            FadeRoute(
              widget: EditProfile(
                isUpdated: (value) {
                  if (value == true) {
                    _getUserData();
                  }
                },
              ),
            ),
          );
        },
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

  Widget _buildUserPosts() {
    if (view == 'grid') {
      return _isInitialLoading
          ? Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: InitLoader(),
            )
          : _isGettingServerData == false && data.length == 0
              ? Container(
                  padding: EdgeInsets.only(top: 30.0),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'No Post',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                )
              : GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemCount: data == null
                      ? 0
                      : allProducts - data.length > 0
                          ? data.length + 3
                          : data.length,
                  itemBuilder: (context, index) {
                    if (index < data.length) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            FadeRoute(
                              widget: Details(
                                  loggedInBussinessId: loggedInBussinessId,
                                  singlePost: data[index]),
                            ),
                          );
                        },
                        child: Stack(
                          fit: StackFit.expand,
                          children: <Widget>[
                            CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: data[index].productPhoto[0].filename,
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) =>
                                      CupertinoActivityIndicator(),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                            if (data[index].productPhoto.toList().length != 1)
                              Positioned(
                                top: 6.0,
                                right: 6.0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                  padding: EdgeInsets.all(5.0),
                                  child: Text(
                                    '${data[index].productPhoto.toList().length - 1}+',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10.0),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    } else if (allProducts - data.length > 0) {
                      return Loader3();
                    } else {
                      return null;
                    }
                  },
                );
    } else if (view == 'feed') {
      return _isInitialLoading
          ? Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: InitLoader(),
            )
          : _isGettingServerData == false && data.length == 0
              ? Container(
                  padding: EdgeInsets.only(top: 30.0),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'No Post',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  separatorBuilder: (context, index) => Divider(),
                  itemCount: data == null
                      ? 0
                      : allProducts - data.length > 0
                          ? data.length + 1
                          : data.length,
                  itemBuilder: (context, index) {
                    if (index < data.length) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          AccountTopSection(
                            profilePic: businessProfilePhoto,
                            businessName: name,
                            businessLocation: location,
                          ),
                          PostSection(
                            postImage: data[index].productPhoto,
                            activeImage: (value) => _changeActivePhoto(value),
                          ),
                          BottomSection(
                              loggedInBussinessId: loggedInBussinessId,
                              bussinessId: data[index].bussiness,
                              postImage: data[index].productPhoto,
                              activePhoto: activePhoto,
                              callNo: data[index].callNumber,
                              whatsapp: data[index].whatsappNumber),
                          PostDetails(caption: data[index].caption),
                        ],
                      );
                    } else if (allProducts - data.length > 0) {
                      return Loader4();
                    } else {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: Center(
                          child: data.length > 15
                              ? Text(
                                  'no more data',
                                  style: TextStyle(color: Colors.teal),
                                )
                              : Text(''),
                        ),
                      );
                    }
                  },
                );
    }
    return null;
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

  Future fetchProduct(url, removeListData, firstLoading) async {
    setState(() {
      _isInitialLoading = firstLoading ? true : false;
      _isGettingServerData = true;
    });

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString(userToken);

    Map<String, String> headers = {
//      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Token $token',
    };
    print(headers);

    final response = await http.get(url, headers: headers);
    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      var productData = json.decode(response.body);
      nextUrl = productData['next'];

      // get bussiness_id if user loggedIn
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      var _businessId = localStorage.getInt(businessId);
      if (_businessId != null) {
        setState(() {
          loggedInBussinessId = _businessId;
        });
      }

      setState(() {
        Iterable list = productData['results'];
        allProducts = productData['count'];
        if (removeListData) {
          data = list.map((model) => Product.fromJson(model)).toList();
        } else {
          data.addAll(list.map((model) => Product.fromJson(model)).toList());
        }
      });
//      print(data);
    } else {
      throw Exception('failed to load data from internet');
    }

    setState(() {
      _isInitialLoading = false;
      _isGettingServerData = false;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }

  @override
  void initState() {
    super.initState();
    _getUserData();
    fetchProduct(VENDOR_POST, removeListData = true, firstLoading = true);

    if (widget.fromLogging == true) {
      _notification('Welcome to windowshoppi', Colors.black, Colors.red);
    }

    _scrollController.addListener(
      () {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          if (nextUrl != null && _isGettingServerData == false) {
            fetchProduct(nextUrl, removeListData = false, firstLoading = false);
          }
        }
      },
    );
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
    var businessAccountId = localStorage.getInt(businessId);

    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Token $token",
    };

    //add headers
    request.headers.addAll(headers);

    request.fields['bussiness'] = businessAccountId.toString();
    request.fields['caption'] = caption;

    // send
    var response = await request.send();

    // listen for response
    response.stream.transform(utf8.decoder).listen((result) {
      if (result == '"success"') {
        clearImage(); // remove images
        _notification('Post created successfully', Colors.black, Colors.red);
        fetchProduct(VENDOR_POST, removeListData = true, firstLoading = true);
      }
    });
  }

  _changeActivePhoto(value) async {
    setState(() {
      activePhoto = value;
    });
  }

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
                ? InitLoader()
                : ListView(
                    controller: _scrollController,
                    physics: BouncingScrollPhysics(),
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

                          await showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              var res = _uploadPost(postCaptionText, _images);
                              res.then(
                                (value) => {
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
                        child: ListView(
                          children: <Widget>[
                            _postCaption(),
                            Divider(),
                            Container(
                              child: GridView.count(
                                physics: ScrollPhysics(),
                                shrinkWrap: true,
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
//                            Expanded(
//                              flex: 2,
//                              child: GridView.count(
//                                physics: BouncingScrollPhysics(),
//                                crossAxisCount: 3,
//                              ),
//                            ),
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
