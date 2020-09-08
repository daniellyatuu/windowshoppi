import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:windowshoppi/models/global.dart';
import 'package:windowshoppi/models/local_storage_keys.dart';
import 'package:windowshoppi/models/product.dart';
import 'package:http/http.dart' as http;

class EditProduct extends StatefulWidget {
  final Product editPost;
  final String newCaption;
  EditProduct({Key key, this.editPost, this.newCaption}) : super(key: key);

  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final _postFormKey = GlobalKey<FormState>();

  bool _isUpdating = false;
  String postCaptionText;

  Future _updatePost(id, caption) async {
    String url = UPDATE_POST + '$id/';

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString(userToken);

    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Token $token',
    };
    var postData = {
      'caption': caption,
    };

    final response = await http.put(
      url,
      headers: headers,
      body: jsonEncode(postData),
    );

    await Future.delayed(Duration(milliseconds: 400));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      Navigator.of(context).pop(data);
    }
  }

  Widget _postCaption(caption, img) {
    return Row(
      children: <Widget>[
        img == ''
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
        SizedBox(width: 10.0),
        Expanded(
          child: TextFormField(
            maxLines: null,
            keyboardType: TextInputType.multiline,
            initialValue: widget.newCaption != '' ? widget.newCaption : caption,
            decoration: InputDecoration(
              hintText: 'Write Caption...',
              border: InputBorder.none,
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'caption is required';
              }
              return null;
            },
            onSaved: (value) => postCaptionText = value,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var post = widget.editPost;
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Post'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: AbsorbPointer(
              absorbing: _isUpdating ? true : false,
              child: GestureDetector(
                onTap: () async {
                  if (_postFormKey.currentState.validate()) {
                    _postFormKey.currentState.save();

                    setState(() {
                      _isUpdating = true;
                    });
                    await _updatePost(widget.editPost.id, postCaptionText);
                    setState(() {
                      _isUpdating = false;
                    });
                  }
                },
                child: Row(
                  children: <Widget>[
                    if (_isUpdating == true)
                      Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: SizedBox(
                          width: 20.0,
                          height: 20.0,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.0,
                            backgroundColor: Colors.white,
                          ),
                        ),
                      ),
                    if (_isUpdating == false)
                      Text('SAVE ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                    if (_isUpdating == false) Icon(Icons.send, size: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _postFormKey,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: <Widget>[
                _postCaption(post.caption, post.accountPic),
                Divider(),
                Container(
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemCount: post.productPhoto.length,
                    itemBuilder: (context, index) {
                      return Stack(
                        fit: StackFit.expand,
                        children: <Widget>[
                          CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: post.productPhoto[index].filename,
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) =>
                                    CupertinoActivityIndicator(),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
