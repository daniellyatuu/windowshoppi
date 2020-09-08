import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:windowshoppi/models/local_storage_keys.dart';
import 'package:windowshoppi/models/product.dart';
import 'package:windowshoppi/products/EditProduct.dart';
import 'package:windowshoppi/routes/fade_transition.dart';
import 'package:windowshoppi/account/account.dart';
import 'package:http/http.dart' as http;
import 'package:windowshoppi/models/global.dart';

class TopSection extends StatefulWidget {
  final Product post;
  final Function(bool) onDeletePost;
  final Function(bool) isDataUpdated;
  final int loggedInBussinessId;
  TopSection({
    Key key,
    this.loggedInBussinessId,
    this.onDeletePost,
    this.post,
    this.isDataUpdated,
  }) : super(key: key);

  @override
  _TopSectionState createState() => _TopSectionState();
}

class _TopSectionState extends State<TopSection> {
  String _caption = '';

  void _deletePost(id) async {
    String url = UPDATE_POST + '$id/';

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString(userToken);

    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Token $token',
    };

    var postData = {
      'active': 0,
    };

    final response = await http.put(
      url,
      headers: headers,
      body: jsonEncode(postData),
    );
    if (response.statusCode == 200) {
      widget.onDeletePost(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              if (widget.post.bussiness != widget.loggedInBussinessId)
                Navigator.push(
                  context,
                  FadeRoute(
                    widget: ProfilePage(bussinessId: widget.post.bussiness),
                  ),
                );
            },
            child: Row(
              children: <Widget>[
//                CircleAvatar(
//                  radius: 35.0,
//                  backgroundColor: Colors.grey[300],
//                  child: Icon(Icons.store, size: 30, color: Colors.grey),
//                ),
                widget.post.accountPic == ''
                    ? Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.store, size: 20, color: Colors.grey),
                      )
                    : Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                                'https://images.unsplash.com/photo-1518806118471-f28b20a1d79d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1000&q=80'),
                          ),
                        ),
                      ),
                SizedBox(
                  width: 10.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Text(
                        '${widget.post.accountName}',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Text(
                        '${widget.post.businessLocation}',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 13.0),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          widget.post.bussiness != widget.loggedInBussinessId
              ? OutlineButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      FadeRoute(
                        widget: ProfilePage(bussinessId: widget.post.bussiness),
                      ),
                    );
                  },
                  child: Text(
                    "visit",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  borderSide: BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    side: BorderSide(
                      color: Colors.red,
                    ),
                  ),
                )
              : IconButton(
                  onPressed: () async {
                    var postAction = await showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: SingleChildScrollView(
                            child: Container(
                              width: MediaQuery.of(context).size.width / 2,
                              child: Center(
                                child: ListView(
                                  physics: ScrollPhysics(),
                                  shrinkWrap: true,
                                  children: [
                                    ListTile(
                                      onTap: () => Navigator.of(context).pop({
                                        'status': 'edit',
                                        'id': widget.post.id,
                                      }),
                                      dense: true,
                                      leading: Icon(Icons.edit),
                                      title: Text('Edit'),
                                    ),
                                    ListTile(
                                      onTap: () => Navigator.of(context).pop({
                                        'status': 'delete',
                                        'id': widget.post.id,
                                      }),
                                      dense: true,
                                      leading: Icon(Icons.delete),
                                      title: Text('Delete'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                    if (postAction != null) {
                      if (postAction['status'] == 'delete') {
                        var deletePost = await showDialog(
                          context: context,
                          builder: (context) => Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: SingleChildScrollView(
                              child: Container(
                                width: MediaQuery.of(context).size.width / 2,
                                child: Center(
                                  child: ListView(
                                    physics: ScrollPhysics(),
                                    shrinkWrap: true,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 16.0),
                                        child: Center(
                                          child: Text(
                                            'Confirm Deletion',
                                            style: Theme.of(context)
                                                .textTheme
                                                // ignore: deprecated_member_use
                                                .title,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 16.0),
                                        child: Center(
                                          child: Text(
                                            'Delete this post?',
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption,
                                          ),
                                        ),
                                      ),
                                      Divider(),
                                      ListTile(
                                        onTap: () => Navigator.of(context).pop({
                                          'confirm': 'yes',
                                          'id': widget.post.id,
                                        }),
                                        dense: true,
                                        leading: Icon(Icons.warning,
                                            color: Colors.red[300]),
                                        title: Text(
                                          'Delete',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red[300]),
                                        ),
                                      ),
                                      Divider(),
                                      ListTile(
                                        onTap: () =>
                                            Navigator.of(context).pop(),
                                        dense: true,
                                        leading: Icon(Icons.clear),
                                        title: Text('Don\'t delete'),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                        if (deletePost != null) {
                          if (deletePost['confirm'] == 'yes') {
                            _deletePost(deletePost['id']);
                          }
                        }
                      } else {
                        var result = await Navigator.push(
                          context,
                          FadeRoute(
                            widget: EditProduct(
                              editPost: widget.post,
                              newCaption: _caption,
                              // newCaption:
                            ),
                          ),
                        );
                        if (result != null) {
                          setState(() {
                            _caption = result['caption'];
                          });
                          widget.isDataUpdated(true);
                        }
                      }
                    }
                  },
                  icon: Icon(Icons.more_vert),
                ),
        ],
      ),
    );
  }
}
