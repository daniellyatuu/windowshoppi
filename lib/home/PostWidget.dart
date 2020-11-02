// import 'package:extended_image/extended_image.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:windowshoppi/models/post.dart';
// import 'package:windowshoppi/products/details/details.dart';
// import 'package:windowshoppi/routes/fade_transition.dart';
//
// class PostWidget extends StatelessWidget {
//   final Post post;
//   const PostWidget({Key key, @required this.post}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(3),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.all(Radius.circular(10.0)),
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.all(Radius.circular(6.0)),
//         child: GestureDetector(
//           onTap: () async {
//             var res = await Navigator.push(
//               context,
//               FadeRoute(
//                 widget: Details(
//                     // loggedInBussinessId: loggedInBussinessId,
//                     // singlePost: data[index],
//                     ),
//               ),
//             );
//             // if (res == 'deleted') {
//             //   setState(() {
//             //     allProducts = allProducts - 1;
//             //     data.remove(data[index]);
//             //   });
//             //   _notification(
//             //       'post deleted successfully', Colors.black, Colors.red);
//             // } else if (res == 'updated') {
//             //   refresh();
//             // }
//           },
//           child: Stack(
//             fit: StackFit.expand,
//             children: <Widget>[
//               ExtendedImage.network(
//                 // data[index]
//                 //     .productPhoto[0]
//                 //     .filename
//                 post.productPhoto[0].filename,
//                 cache: true,
//                 loadStateChanged: (ExtendedImageState state) {
//                   switch (state.extendedImageLoadState) {
//                     case LoadState.loading:
//                       return CupertinoActivityIndicator();
//                       break;
//
//                     ///if you don't want override completed widget
//                     ///please return null or state.completedWidget
//                     //return null;
//                     //return state.completedWidget;
//                     case LoadState.completed:
//                       return ExtendedRawImage(
//                         fit: BoxFit.cover,
//                         image: state.extendedImageInfo?.image,
//                       );
//                       break;
//                     case LoadState.failed:
//                       // _controller.reset();
//                       return GestureDetector(
//                         child: Center(
//                           child: Icon(Icons.refresh),
//                         ),
//                         onTap: () {
//                           state.reLoadImage();
//                         },
//                       );
//                       break;
//                   }
//                   return null;
//                 },
//               ),
//               if (post.productPhoto.toList().length != 1)
//                 Positioned(
//                   top: 6.0,
//                   right: 6.0,
//                   child: Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(5.0),
//                       color: Colors.black.withOpacity(0.5),
//                     ),
//                     padding: EdgeInsets.all(5.0),
//                     child: Text(
//                       '${post.productPhoto.toList().length - 1}+',
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 10.0),
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
