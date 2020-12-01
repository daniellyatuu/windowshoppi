import 'package:flutter/material.dart';
import 'package:windowshoppi/src/account/account_files.dart';

class PostListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        PostHeader(),
        // TopSection(
        //   post: data[index],
        //   loggedInBussinessId: loggedInBussinessId,
        //   onDeletePost: (value) => _removePost(data[index]),
        //   isDataUpdated: (value) => _updateCaption(),
        // ),
        // TopSection(
        //   post: data[index],
        //   loggedInBussinessId: loggedInBussinessId,
        //   onDeletePost: (value) => _removePost(data[index]),
        //   isDataUpdated: (value) => value
        //       ? fetchProduct(VENDOR_POST,
        //       removeListData = true, firstLoading = true)
        //       : null,
        // ),
        // TopSection(
        //   post: data[index],
        //   loggedInBussinessId: loggedInBussinessId,
        //   onDeletePost: (value) => _removePost(data[index]),
        //   isDataUpdated: (value) =>
        //   value ? refresh() : null,
        // ),
        // PostSection(
        //   postImage: data[index].productPhoto,
        //   activeImage: (value) => _changeActivePhoto(value),
        // ),
        // BottomSection(
        //     loggedInBussinessId: loggedInBussinessId,
        //     bussinessId: data[index].bussiness,
        //     postImage: data[index].productPhoto,
        //     activePhoto: activePhoto,
        //     callNo: data[index].callNumber,
        //     whatsapp: data[index].whatsappNumber),
        // PostDetails(caption: data[index].caption),
      ],
    );
  }
}
