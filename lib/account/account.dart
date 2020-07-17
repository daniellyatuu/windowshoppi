import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:windowshoppi/explore/post_details.dart';
import 'package:windowshoppi/explore/post_section.dart';
import 'package:windowshoppi/products/details/bottom_section.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:windowshoppi/products/details/details.dart';
import 'package:windowshoppi/routes/fade_transition.dart';
import 'account_top_section.dart';

class ProfilePage extends StatefulWidget {
  _ProfilePage createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin<ProfilePage> {
  String view = "grid"; // default view

  Widget _accountHeader() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          _topAccountSection(),
          _accountCommunication(),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(top: 8.0),
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

  Widget _accountCommunication() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: RaisedButton(
              color: Colors.blue,
              onPressed: () {},
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
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: RaisedButton(
              color: Color(0xFF06B862),
              onPressed: () {},
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
          BottomSection(),
          PostDetails(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // reloads state when opened again

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'windowshoppi ',
          style: TextStyle(fontFamily: 'Itim'),
        ),
      ),
      body: ListView(
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

  changeView(String viewName) {
    setState(() {
      view = viewName;
    });
  }

  // ensures state is kept when switching pages
  @override
  bool get wantKeepAlive => true;
}
