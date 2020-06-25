import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
//import 'package:windowshoppi/account/account.dart';

class ProductDetails extends StatefulWidget {
  final String imageUrl;
  ProductDetails({Key key, @required this.imageUrl}) : super(key: key);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('product details'),
      ),
      body: ListView(
        children: <Widget>[
          TopSection(),
          ImageSection(postImage: widget.imageUrl),
          BottomSection(postImage: widget.imageUrl),
          DescriptionSection(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
//        onTap: onTappedBar,
//        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('home'),
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            title: Text('explore'),
            backgroundColor: Colors.red[900],
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.search),
            title: Text('search'),
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            title: Text('my account'),
            backgroundColor: Colors.green[900],
          ),
        ],
      ),
    );
  }
}

class TopSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 22.0,
        child: CircleAvatar(
          radius: 20.0,
          backgroundColor: Colors.white,
          backgroundImage: AssetImage('images/shop.jpg'),
        ),
      ),
      title: Text(
        'account name',
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        'location',
        overflow: TextOverflow.ellipsis,
      ),
      trailing: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
          side: BorderSide(
            color: Colors.red,
          ),
        ),
        onPressed: () {
//          Navigator.push(
//            context,
//            MaterialPageRoute(
//              builder: (context) => PageAccount(),
//            ),
//          );
        },
        child: Text('visit'),
      ),
    );
  }
}

class ImageSection extends StatefulWidget {
  final String postImage;
  ImageSection({Key key, this.postImage}) : super(key: key);

  @override
  _ImageSectionState createState() => _ImageSectionState();
}

class _ImageSectionState extends State<ImageSection> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductImage(imageUrl: widget.postImage),
          ),
        );
      },
      child: Container(
        height: MediaQuery.of(context).size.height / 2,
        child: Hero(
          tag: '1',
          child: FadeInImage.memoryNetwork(
            placeholder: kTransparentImage,
            image: widget.postImage,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class BottomSection extends StatefulWidget {
  final String postImage;
  BottomSection({Key key, this.postImage}) : super(key: key);
  @override
  _BottomSectionState createState() => _BottomSectionState();
}

class _BottomSectionState extends State<BottomSection> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    String x = widget.postImage;
//    print(x);
//    final bytes = Io.File('images/shop.jpg').readAsBytesSync();

//    String img64 = base64Encode(bytes);
//    print(img64.substring(0, 100));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              IconButton(
                onPressed: () {
                  call();
                },
                icon: FaIcon(FontAwesomeIcons.phoneSquareAlt),
              ),
              IconButton(
                onPressed: () {
                  FlutterOpenWhatsapp.sendSingleMessage(
                      "+255625636291", "Hello");
                },
                icon: FaIcon(FontAwesomeIcons.whatsappSquare),
              ),
            ],
          ),
          IconButton(
            onPressed: () {
              FlutterShareMe().shareToWhatsApp(
                  base64Image: widget.postImage,
                  msg: 'product from windowshoppi');
            },
            icon: FaIcon(FontAwesomeIcons.shareAlt),
          ),
        ],
      ),
    );
  }
}

call() {
  String phoneNumber = "tel:0653900085";
  launch(phoneNumber);
}

class DescriptionSection extends StatefulWidget {
  @override
  _DescriptionSectionState createState() => _DescriptionSectionState();
}

class _DescriptionSectionState extends State<DescriptionSection> {
  String description =
      'product desction in here product product desction in here product d product desction in here product dproduct desction in  product desction in here product d product desction in here product d here product d  desction in here product desction in hereproduct desction in here product desction in hereproduct desction in hereproduct desction in here product desction in here';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: Text(
        description,
        textAlign: TextAlign.justify,
      ),
    );
  }
}

class ProductImage extends StatelessWidget {
  final String imageUrl;
  ProductImage({Key key, this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Hero(
          tag: '1',
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Center(
              child: Image.network(imageUrl),
            ),
          ),
        ),
      ),
    );
  }
}
