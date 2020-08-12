import 'package:flutter/material.dart';
import 'package:windowshoppi/routes/fade_transition.dart';
import 'package:windowshoppi/account/account.dart';

class TopSection extends StatelessWidget {
  final String account, location;
  final int loggedInBussinessId, bussinessId;
  TopSection(
      {Key key,
      this.account,
      this.location,
      this.loggedInBussinessId,
      this.bussinessId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              if (bussinessId != loggedInBussinessId)
                Navigator.push(
                  context,
                  FadeRoute(
                    widget: ProfilePage(bussinessId: bussinessId),
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
                        '$account',
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
                        '$location',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 13.0),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          bussinessId != loggedInBussinessId
              ? OutlineButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      FadeRoute(
                        widget: ProfilePage(bussinessId: bussinessId),
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
                  onPressed: () {},
                  icon: Icon(Icons.more_vert),
                ),
        ],
      ),
    );
  }
}
