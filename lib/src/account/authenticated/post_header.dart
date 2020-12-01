import 'package:flutter/material.dart';

class PostHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
            onTap: () {},
            child: Row(
              children: <Widget>[
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.store, size: 20, color: Colors.grey),
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
                        'widget.post.accountName}',
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
                        'widget.post.businessLocation}',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 13.0),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          OutlineButton(
            onPressed: () {},
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
          ),
          // IconButton(
          //   onPressed: () async {
          //     var postAction = await showDialog(
          //       context: context,
          //       builder: (context) {
          //         return Dialog(
          //           shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.circular(8.0),
          //           ),
          //           child: SingleChildScrollView(
          //             child: Container(
          //               width: MediaQuery.of(context).size.width / 2,
          //               child: Center(
          //                 child: ListView(
          //                   physics: ScrollPhysics(),
          //                   shrinkWrap: true,
          //                   children: [
          //                     ListTile(
          //                       dense: true,
          //                       leading: Icon(Icons.edit),
          //                       title: Text('Edit'),
          //                     ),
          //                     ListTile(
          //                       dense: true,
          //                       leading: Icon(Icons.delete),
          //                       title: Text('Delete'),
          //                     ),
          //                   ],
          //                 ),
          //               ),
          //             ),
          //           ),
          //         );
          //       },
          //     );
          //     // if (postAction != null) {
          //     //   if (postAction['status'] == 'delete') {
          //     //     var deletePost = await showDialog(
          //     //       context: context,
          //     //       builder: (context) => Dialog(
          //     //         shape: RoundedRectangleBorder(
          //     //           borderRadius: BorderRadius.circular(8.0),
          //     //         ),
          //     //         child: SingleChildScrollView(
          //     //           child: Container(
          //     //             width: MediaQuery.of(context).size.width / 2,
          //     //             child: Center(
          //     //               child: ListView(
          //     //                 physics: ScrollPhysics(),
          //     //                 shrinkWrap: true,
          //     //                 children: [
          //     //                   Padding(
          //     //                     padding: const EdgeInsets.only(top: 16.0),
          //     //                     child: Center(
          //     //                       child: Text(
          //     //                         'Confirm Deletion',
          //     //                         style: Theme.of(context)
          //     //                             .textTheme
          //     //                             // ignore: deprecated_member_use
          //     //                             .title,
          //     //                       ),
          //     //                     ),
          //     //                   ),
          //     //                   Padding(
          //     //                     padding: const EdgeInsets.only(top: 16.0),
          //     //                     child: Center(
          //     //                       child: Text(
          //     //                         'Delete this post?',
          //     //                         style:
          //     //                             Theme.of(context).textTheme.caption,
          //     //                       ),
          //     //                     ),
          //     //                   ),
          //     //                   Divider(),
          //     //                   ListTile(
          //     //                     onTap: () => Navigator.of(context).pop({
          //     //                       'confirm': 'yes',
          //     //                       'id': widget.post.id,
          //     //                     }),
          //     //                     dense: true,
          //     //                     leading: Icon(Icons.warning,
          //     //                         color: Colors.red[300]),
          //     //                     title: Text(
          //     //                       'Delete',
          //     //                       style: TextStyle(
          //     //                           fontWeight: FontWeight.bold,
          //     //                           color: Colors.red[300]),
          //     //                     ),
          //     //                   ),
          //     //                   Divider(),
          //     //                   ListTile(
          //     //                     onTap: () => Navigator.of(context).pop(),
          //     //                     dense: true,
          //     //                     leading: Icon(Icons.clear),
          //     //                     title: Text('Don\'t delete'),
          //     //                   ),
          //     //                 ],
          //     //               ),
          //     //             ),
          //     //           ),
          //     //         ),
          //     //       ),
          //     //     );
          //     //     if (deletePost != null) {
          //     //       if (deletePost['confirm'] == 'yes') {
          //     //         _deletePost(deletePost['id']);
          //     //       }
          //     //     }
          //     //   } else {
          //     //     var result = await Navigator.push(
          //     //       context,
          //     //       FadeRoute(
          //     //         widget: EditProduct(
          //     //           editPost: widget.post,
          //     //           newCaption: _caption,
          //     //           // newCaption:
          //     //         ),
          //     //       ),
          //     //     );
          //     //     if (result != null) {
          //     //       setState(() {
          //     //         _caption = result['caption'];
          //     //       });
          //     //       widget.isDataUpdated(true);
          //     //     }
          //     //   }
          //     // }
          //   },
          //   icon: Icon(Icons.more_vert),
          // ),
        ],
      ),
    );
  }
}
