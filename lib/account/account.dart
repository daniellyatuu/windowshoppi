import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:windowshoppi/explore/post_details.dart';
import 'package:windowshoppi/explore/post_section.dart';
import 'package:windowshoppi/explore/top_section.dart';
import 'package:windowshoppi/models/global.dart';
import 'package:windowshoppi/models/local_storage_keys.dart';
import 'package:windowshoppi/models/product.dart';
import 'package:windowshoppi/products/details/bottom_section.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:windowshoppi/products/details/details.dart';
import 'package:windowshoppi/routes/fade_transition.dart';
import 'package:windowshoppi/widgets/loader.dart';
import 'account_top_section.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  final int bussinessId;
  ProfilePage({this.bussinessId});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ScrollController _scrollController = ScrollController();

  int loggedInBussinessId = 0;

  // business info
  bool _isFetchingBusinessInfo = true;
  var _businessData;

  // fetch product
  bool removeListData, _isGettingServerData, firstLoading;
  bool _isInitialLoading = true;
  int activePhoto = 0;
  var data = new List<Product>();
  String newUrl, nextUrl;
  int allProducts = 0;

  String view = "grid"; // default view

  Widget _accountHeader() {
    return _isFetchingBusinessInfo
        ? Loader5()
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                _topAccountSection(),
                _accountCommunication(),
                if (_businessData['email'] != null)
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      _businessData['email'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                if (_businessData['bio'] != null)
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Text(
                      _businessData['bio'],
                      textAlign: TextAlign.justify,
                    ),
                  ),
              ],
            ),
          );
  }

  Widget _topAccountSection() {
    return Row(
      children: <Widget>[
        _businessData['profile_image'] == null
            ? CircleAvatar(
                radius: 35.0,
                backgroundColor: Colors.grey[300],
                child: Icon(Icons.store, size: 30, color: Colors.grey),
              )
            : CircleAvatar(
                radius: 35.0,
                backgroundColor: Colors.grey[300],
                backgroundImage: NetworkImage('online-image'),
              ),
        Expanded(
          child: ListTile(
            title: Text(_businessData['name']),
            subtitle: Text(_businessData['location_name']),
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

  Widget _accountCommunication() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: RaisedButton(
              color: Colors.blue,
              onPressed: () {
                call(_businessData['call_number']);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FaIcon(
                    FontAwesomeIcons.phone,
                    size: 15.0,
                    color: Colors.white,
                  ),
                  Text(
                    ' CALL',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_businessData['whatsapp_number'] != null)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: RaisedButton(
                color: Color(0xFF06B862),
                onPressed: () {
                  chat(_businessData['whatsapp_number'],
                      "Hi there! I have seen your post on windowshoppi");
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FaIcon(
                      FontAwesomeIcons.whatsapp,
                      size: 15.0,
                      color: Colors.white,
                    ),
                    Text(
                      ' CHAT',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
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

  Widget _buildProfileFollowButton() {
    return Container(
      padding: EdgeInsets.only(top: 4.0),
      child: FlatButton(
        onPressed: () {},
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5.0),
          ),
          alignment: Alignment.center,
          child: Text(
            'edit profile',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          width: 200.0,
          height: 27.0,
        ),
      ),
    );
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
      return _isInitialLoading || _isFetchingBusinessInfo
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
              : ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: data == null
                      ? 0
                      : allProducts - data.length > 0
                          ? data.length + 1
                          : data.length,
                  itemBuilder: (context, index) {
                    if (index < data.length) {
                      return Card(
                        margin: EdgeInsets.symmetric(
                            horizontal: 0.0, vertical: 4.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            TopSection(
                              loggedInBussinessId: loggedInBussinessId,
                              bussinessId: 2,
                              account: data[index].accountName,
                              location: data[index].businessLocation,
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
                        ),
                      );
                    } else if (allProducts - data.length > 0) {
                      return Loader2();
                    } else {
                      return null;
                    }
                  },
                );
    }
    return null;
  }

  Future _fetchBusinessInfo(id) async {
    setState(() {
      _isFetchingBusinessInfo = true;
    });

    var url = BUSINESS_INFO + id.toString() + '/';

    final response = await http.get(url);

    if (response.statusCode == 200) {
      var businessData = json.decode(response.body);

      setState(() {
        var data = businessData;
        _businessData = data;
      });
      print(_businessData);
    } else {
      throw Exception('failed to load data from internet');
    }

    setState(() {
      _isFetchingBusinessInfo = false;
    });
  }

  Future fetchProduct(url, removeListData, firstLoading) async {
    setState(() {
      _isInitialLoading = firstLoading ? true : false;
      _isGettingServerData = true;
    });

    if (_isInitialLoading) {
      newUrl = url + widget.bussinessId.toString() + '/';
    } else {
      newUrl = url;
    }

    final response = await http.get(newUrl);

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

  _changeActivePhoto(value) async {
    setState(() {
      activePhoto = value;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchBusinessInfo(widget.bussinessId);
    fetchProduct(VENDOR_POST, removeListData = true, firstLoading = true);

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

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isFetchingBusinessInfo ? 'windowshoppi' : _businessData['name'],
          style: TextStyle(fontFamily: 'Itim'),
        ),
      ),
      body: ListView(
        controller: _scrollController,
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          _accountHeader(),
          Divider(height: 5),
          _buildImageViewButtonBar(),
          Divider(height: 0.0),
          _buildUserPosts(),
        ],
      ),
    );
  }
}
