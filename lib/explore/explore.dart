import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:windowshoppi/products/details/bottom_section.dart';
import 'package:windowshoppi/drawer/app_drawer.dart';
import 'package:windowshoppi/horizontal_list/horizontal_list.dart';
import 'package:windowshoppi/myappbar/select_country.dart';
import 'top_section.dart';
import 'post_section.dart';
import 'post_details.dart';
import 'package:windowshoppi/models/product.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_pro/carousel_pro.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Explore extends StatefulWidget {
  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'windowshoppi',
          style: TextStyle(fontFamily: 'Itim'),
        ),
        actions: <Widget>[
          SelectCountry(),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: fetchProduct(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
          }
          return snapshot.hasData
              ? SinglePost(product: snapshot.data)
              : Center(child: CircularProgressIndicator(strokeWidth: 3.0));
        },
      ),
    );
  }
}

class SinglePost extends StatelessWidget {
  final List<Product> product;
  SinglePost({Key key, this.product}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: product.length,
        itemBuilder: (context, index) {
          return Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TopSection(
                  account: product[index].accountName,
                  location: product[index].businessLocation,
                ),
                AspectRatio(
                  aspectRatio: 1,
                  child: Carousel(
                    boxFit: BoxFit.cover,
                    autoplay: false,
                    animationCurve: Curves.fastOutSlowIn,
                    dotSize: 4.0,
                    dotIncreasedColor: Color(0xFFFF335C),
                    dotBgColor: Colors.transparent,
                    dotPosition: DotPosition.bottomCenter,
                    dotColor: Colors.black,
                    dotVerticalPadding: 2.0,
                    showIndicator: true,
                    indicatorBgPadding: 5.0,
                    images: [
                      for (var image in product[index].productPhoto)
//                        Image.network(
//                          image.filename,
//                          fit: BoxFit.cover,
//                          loadingBuilder: (BuildContext context, Widget child,
//                              ImageChunkEvent loadingProgress) {
//                            if (loadingProgress == null) return child;
//                            return Center(
//                              child: CupertinoActivityIndicator(),
//                            );
//                          },
//                        ),
                        CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: image.filename,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) =>
                                  CupertinoActivityIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
//                        Column(
//                          mainAxisAlignment: MainAxisAlignment.start,
//                          mainAxisSize: MainAxisSize.min,
//                          crossAxisAlignment: CrossAxisAlignment.stretch,
//                          children: <Widget>[
//                            Flexible(
//                              fit: FlexFit.loose,
//                              child: FadeInImage.memoryNetwork(
//                                placeholder: kTransparentImage,
//                                image: image.filename,
//                                fit: BoxFit.cover,
//                              ),
//                            ),
//                          ],
//                        ),
                    ],
                  ),
                ),
//                PostSection(imageUrl: imgUrl),
//          BottomSection(postImage: imgUrl),
                PostDetails(),
              ],
            ),
          );
        });
  }
}

//Column(
//children: <Widget>[
//AppCategory(),
//Expanded(
//child: ListView.builder(
//itemCount: imageList.length,
//itemBuilder: (context, index) {
//return SinglePost(imgUrl: imageList[index]);
//},
//),
//),
//],
//),

/// This is the stateless widget that the main application instantiates.
class MyStatelessWidget extends StatelessWidget {
  MyStatelessWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Image.network(
        'https://example.com/image.jpg',
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes
                  : null,
            ),
          );
        },
      ),
    );
  }
}
