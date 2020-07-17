import 'package:flutter/material.dart';
import 'package:windowshoppi/routes/fade_transition.dart';
import 'package:windowshoppi/account/account.dart';

class TopSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
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
                      'Account name',
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
                      'Location',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 13.0),
                    ),
                  ),
                ],
              ),
            ],
          ),
          OutlineButton(
            onPressed: () {
              Navigator.push(
                context,
                FadeRoute(
                  widget: ProfilePage(),
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
          ),
        ],
      ),
    );
  }
}
