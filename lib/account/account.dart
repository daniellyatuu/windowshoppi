import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:windowshoppi/explore/post_details.dart';
import 'package:windowshoppi/explore/post_section.dart';
import 'package:windowshoppi/products/details/bottom_section.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfilePage extends StatefulWidget {
  _ProfilePage createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin<ProfilePage> {
  //  final String profileId;
  String view = "grid"; // default view

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
          flex: 1,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: RaisedButton(
                      color: Colors.blue,
                      onPressed: () {},
                      child: Row(
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: RaisedButton(
                      color: Colors.lightGreen[400],
                      onPressed: () {},
                      child: Row(
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
                ],
              ),
//              Row(
//                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                children: <Widget>[
//                  _buildStatColumn("posts", 2),
////                  _buildStatColumn("followers", 3),
////                  _buildStatColumn("following", 45),
//                ],
//              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _buildProfileFollowButton(),
                ],
              ),
            ],
          ),
        )
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
            ))
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
          icon: Icon(Icons.grid_on, color: isActiveButtonColor("grid")),
          onPressed: () {
            changeView("grid");
          },
        ),
        IconButton(
          icon: Icon(Icons.list, color: isActiveButtonColor("feed")),
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
              borderRadius: BorderRadius.circular(5.0)),
          alignment: Alignment.center,
          child: Text('edit profile',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
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
    'https://www.hindipro.com/wp-content/uploads/2019/12/avatar-images-of-god-krishna-and-radha-hinduism.jpg',
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
          return FadeInImage.memoryNetwork(
            placeholder: kTransparentImage,
            image: _posts[index],
            fit: BoxFit.cover,
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
//          TopSection(),
          PostSection(imageUrl: imgUrl),
          BottomSection(postImage: imgUrl),
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
          ' business name',
        ),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                _topAccountSection(),
                Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Text(
                      'name',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(top: 1.0),
                  child: Text(
                    'some description about the account well be in here',
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          _buildImageViewButtonBar(),
          Divider(height: 0.0),
//          buildUserPosts(),
          _buildUserPosts(),
        ],
      ),
    );
//        });
  }

  changeView(String viewName) {
    setState(() {
      view = viewName;
    });
  }

  int _countFollowings(Map followings) {
    int count = 0;

    void countValues(key, value) {
      if (value) {
        count += 1;
      }
    }

//    followings.forEach(countValues);

//    return count;
  }

  // ensures state is kept when switching pages
  @override
  bool get wantKeepAlive => true;
}

//class ImageTile extends StatelessWidget {
////  final ImagePost imagePost;
////
////  ImageTile(this.imagePost);
//
//  clickedImage(BuildContext context) {
//    Navigator.of(context)
//        .push(MaterialPageRoute<bool>(builder: (BuildContext context) {
//      return Center(
//        child: Scaffold(
//            appBar: AppBar(
//              title: Text('Photo',
//                  style: TextStyle(
//                      color: Colors.black, fontWeight: FontWeight.bold)),
//              backgroundColor: Colors.white,
//            ),
//            body: ListView(
//              children: <Widget>[
////                Container(
////                  child: imagePost,
////                ),
//              ],
//            )),
//      );
//    }));
//  }
//
//  Widget build(BuildContext context) {
//    return GestureDetector(
////      onTap: () => clickedImage(context),
////      child: Image.network(imagePost.mediaUrl, fit: BoxFit.cover),
//        );
//  }
//}

//void openProfile(BuildContext context, String userId) {
//  Navigator.of(context)
//      .push(MaterialPageRoute<bool>(builder: (BuildContext context) {
//    return ProfilePage();
//  }));
//}

//return GridView.count(
//crossAxisCount: 3,
//childAspectRatio: 1.0,
//padding: const EdgeInsets.all(0.5),
//mainAxisSpacing: 1.5,
//crossAxisSpacing: 1.5,
//shrinkWrap: true,
//physics: NeverScrollableScrollPhysics(),
//// Generate 100 widgets that display their index in the List.
//children: List.generate(99, (index) {
//return Container(
//height: double.infinity,
//width: double.infinity,
//color: Colors.blue,
//child: Center(child: Text('Item $index')),
//);
//}),
//);
