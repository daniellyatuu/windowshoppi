import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:windowshoppi/models/product.dart';

class Products extends StatelessWidget {
  final List<Product> products;
  Products({Key key, this.products}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: StaggeredGridView.countBuilder(
            physics: BouncingScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 1,
            mainAxisSpacing: 1,
            itemCount: products.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
//                  Navigator.push(
//                    context,
//                    FadeRoute(
//                      widget: Details(imageUrl: imageList[imageUrl]),
//                    ),
//                  );
                },
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(6.0)),
                    child: ExtendedImage.network(
                      products[index].productPhoto[0].filename,
                      cache: true,
                      loadStateChanged: (ExtendedImageState state) {
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
                              image: state.extendedImageInfo?.image,
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
              );
            },
            staggeredTileBuilder: (index) {
              return StaggeredTile.count(1, index.isEven ? 1.2 : 1.0);
            }),
      ),
    );
  }
}

//class Products extends StatefulWidget {
//  final List<Product> products;
//  Products({this.products});
//  @override
//  _ProductsState createState() => _ProductsState();
//}
//
//class _ProductsState extends State<Products> {
//  //  check internet connection ..start
//  //  var _connectionStatus = 'Unknown';
//  Connectivity connectivity;
//
//  StreamSubscription<ConnectivityResult> subscription;
//
//  bool isConnected;
//
//  @override
//  void initState() {
//    // TODO: implement initState
//    super.initState();
//    connectivity = Connectivity();
//    subscription = connectivity.onConnectivityChanged.listen(
//      (ConnectivityResult result) {
////        print(result);
//        if (result == ConnectivityResult.wifi ||
//            result == ConnectivityResult.mobile) {
//          setState(() {
//            isConnected = true;
////            print('internet connected');
//            Scaffold.of(context).removeCurrentSnackBar();
//          });
//        } else {
//          setState(() {
//            isConnected = false;
//
//            Scaffold.of(context).showSnackBar(
//              SnackBar(
//                duration: Duration(seconds: 15),
//                content: Row(
//                  children: <Widget>[
//                    SizedBox(
//                      width: 20,
//                      height: 20,
//                      child: CupertinoActivityIndicator(),
//                    ),
//                    SizedBox(
//                      width: 10.0,
//                    ),
//                    Expanded(child: Text('No internet connection')),
//                  ],
//                ),
//                action: SnackBarAction(
//                  label: 'hide',
//                  onPressed: () {
//                    Scaffold.of(context).hideCurrentSnackBar();
//                  },
//                ),
//              ),
//            );
//          });
//        }
//      },
//    );
//  }
//
//  @override
//  void dispose() {
//    // TODO: implement dispose
//    subscription.cancel();
//    super.dispose();
//  }
//  //  check internet connection ..end
//
//  List<String> imageList = [
//    'https://lh5.googleusercontent.com/proxy/XuQ0Dc8ews6V2G3iQqp8oYWupJdK3s1WxJ_n1cXFaDGmpMzIbceiEgo7i1GqFoz_Ppf4MCe4uWQSXX431u3MgHzlpdUMRoU',
//    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQUTcsi010F5zBOmMN24rnbstMgM3rh8u_dWrWQXPLu_UXuUB1E&s',
//    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQIbNH5TdL5-CyiwdqglmGeKdHgIl8-BcFFTHMWUIVis5-q0I2T&s',
//    'https://api.time.com/wp-content/uploads/2018/11/sweetfoam-sustainable-product.jpg?quality=85',
//    'https://lh3.googleusercontent.com/kcuyhFJT68FzCgfH-Ow8DdUiL1xgUp6rdAHpSDqF3Eg8j4HQ3O9ANxsyy_EpiTBvhXnLvNvOmI1ygIONDgIV_4xHYyxyd5y5f0EHAQ=w262-l90-sg-rj',
//    'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/iphone11-red-select-2019?wid=940&hei=1112&fmt=png-alpha&qlt=80&.v=1566956144763',
//    'https://static.livebooks.com/abc61dbc6e9c403b917975eb48d2d97d/i/f2c81f819c994f5eb2312f9948520c2a/1/4SoifmQp7LJ6yDtMuFY2x/Swan-Optic-22089.jpg',
//    'https://www.apple.com/v/product-red/o/images/meta/og__dbjwy50zuc02.png?202005090509',
//    'https://api.time.com/wp-content/uploads/2018/11/sweetfoam-sustainable-product.jpg?quality=85',
//    'https://in.canon/media/image/2018/05/03/642e7bbeae5741e3b872e082626c0151_eos6d-mkii-ef-24-70m-l.png',
//  ];
//  @override
//  Widget build(BuildContext context) {
//    return Expanded(
//      child: Container(
//        child: StaggeredGridView.countBuilder(
//            physics: BouncingScrollPhysics(),
//            crossAxisCount: 2,
//            crossAxisSpacing: 1,
//            mainAxisSpacing: 1,
//            itemCount: imageList.length,
//            itemBuilder: (context, imageUrl) {
//              return InkWell(
//                onTap: () {
////                  Navigator.push(
////                    context,
////                    FadeRoute(
////                      widget: Details(imageUrl: imageList[imageUrl]),
////                    ),
////                  );
//                },
//                child: Container(
//                  padding: EdgeInsets.all(5),
//                  decoration: BoxDecoration(
//                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                  ),
//                  child: ClipRRect(
//                    borderRadius: BorderRadius.all(Radius.circular(6.0)),
//                    child: FadeInImage.memoryNetwork(
//                      placeholder: kTransparentImage,
//                      image: imageList[imageUrl],
//                      fit: BoxFit.cover,
//                    ),
//                  ),
//                ),
//              );
//            },
//            staggeredTileBuilder: (index) {
//              return StaggeredTile.count(1, index.isEven ? 1.2 : 1.0);
//            }),
//      ),
//    );
//  }
//}
