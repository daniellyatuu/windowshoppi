import 'package:windowshoppi/src/account/account_files.dart';
import 'package:windowshoppi/src/model/model_files.dart';
import 'package:flutter/material.dart';

class TopHeader extends StatelessWidget {
  final Post post;
  TopHeader({@required this.post});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AccountPageInit(
                    accountId: post.accountId,
                  ),
                ),
              );
            },
            child: Row(
              children: <Widget>[
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                  ),
                  child: FittedBox(
                    child: Icon(Icons.account_circle, color: Colors.grey[300]),
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
                        '${post.username}',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    if (post.taggedLocation != null)
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        child: Text(
                          '${post.taggedLocation}',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 13.0),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
