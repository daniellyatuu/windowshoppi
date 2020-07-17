import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:windowshoppi/routes/fade_transition.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:windowshoppi/account/account_top_section.dart';
import 'package:windowshoppi/explore/post_section.dart';
import 'package:windowshoppi/products/details/details.dart';
import 'package:windowshoppi/explore/post_details.dart';
import 'my_account_bottom_section.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'dart:io';
import 'dart:async';
import 'package:image_picker/image_picker.dart';

class MyAccount extends StatefulWidget {
  @override
  _MyAccountState createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount>
    with AutomaticKeepAliveClientMixin<MyAccount> {
  bool dialVisible = true;
  File file;

  void setDialVisible(bool value) {
    setState(() {
      dialVisible = value;
    });
  }

  SpeedDial buildSpeedDial() {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22.0),
      visible: dialVisible,
      curve: Curves.bounceIn,
      children: [
        SpeedDialChild(
          child: Icon(Icons.camera_alt),
          backgroundColor: Colors.teal,
          onTap: () {
            _openCamera();
          },
          label: 'Take a photo',
          labelStyle: TextStyle(fontWeight: FontWeight.w500),
          labelBackgroundColor: Colors.teal,
        ),
        SpeedDialChild(
          child: Icon(Icons.photo_album),
          backgroundColor: Colors.blue,
          onTap: () {
            _browseFromGallery();
          },
          labelWidget: Container(
            color: Colors.blue,
            margin: EdgeInsets.only(right: 10),
            padding: EdgeInsets.all(6),
            child: Text('Choose from gallery'),
          ),
        ),
      ],
    );
  }

  void _browseFromGallery() async {
    // ignore: deprecated_member_use
    File imageFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1920,
      maxHeight: 1200,
      imageQuality: 80,
    );
    setState(() {
      file = imageFile;
    });
  }

  void _openCamera() async {
    // ignore: deprecated_member_use
    File imageFile = await ImagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1920,
      maxHeight: 1200,
      imageQuality: 80,
    );
    setState(() {
      file = imageFile;
    });
  }

  void clearImage() {
    setState(() {
      file = null;
    });
  }

  String view = "grid"; // default view

  Widget _accountHeader() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          _topAccountSection(),
          _accountDetails(),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(top: 5.0),
            child: Text(
              'daniellyatuu@gmail.com',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(top: 5.0),
            child: Text(
              'account bio in here',
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
        CircleAvatar(
          radius: 35.0,
          backgroundColor: Colors.grey,
          backgroundImage: NetworkImage(
              'https://images.unsplash.com/photo-1518806118471-f28b20a1d79d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80'),
        ),
        Expanded(
          child: ListTile(
            title: Text('business name'),
            subtitle: Text('business location'),
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
                    '+255653900085',
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
                Expanded(
                  child: Text(
                    '+255653900085',
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
              Navigator.push(
                context,
                FadeRoute(
                  widget: Details(imageUrl: _posts[index]),
                ),
              );
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
          PostSection(imageUrl: imgUrl),
          MyAccountBottomSection(postImage: imgUrl),
          PostDetails(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // reloads state when opened again

    return file == null
        ? Scaffold(
            appBar: AppBar(
              title: Text('my account'),
            ),
            body: ListView(
              children: <Widget>[
                _accountHeader(),
                Divider(height: 0.0),
                _buildImageViewButtonBar(),
                Divider(height: 0.0),
                _buildUserPosts(),
              ],
            ),
            floatingActionButton: buildSpeedDial(),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text('Post'),
              leading: IconButton(
                icon: Icon(Icons.clear),
                onPressed: clearImage,
              ),
            ),
          );
  }

  // ensures state is kept when switching pages
  @override
  bool get wantKeepAlive => true;
}
