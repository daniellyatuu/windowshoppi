import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:windowshoppi/src/utilities/constants.dart';

class DiscoverAccount extends StatefulWidget {
  @override
  _DiscoverAccountState createState() => _DiscoverAccountState();
}

class _DiscoverAccountState extends State<DiscoverAccount> {
  // form data
  String _userName;

  Widget _buildUsernameTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(0.0),
          alignment: Alignment.centerLeft,
          child: TextFormField(
            decoration: InputDecoration(
              labelText: 'username',
              prefixIcon: Icon(Icons.person_outline),
              contentPadding: EdgeInsets.symmetric(
                vertical: 0.0,
                horizontal: 10.0,
              ),
              border: OutlineInputBorder(),
              focusedBorder: kFocusedBorder,
              enabledBorder: kEnabledBorder,
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'username is required';
              }
              return null;
            },
            onSaved: (value) => _userName = value,
          ),
        ),
      ],
    );
  }

  Widget _buildNextBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.0),
      child: RaisedButton(
        onPressed: () {},
        color: Colors.white,
        child: Text(
          'NEXT',
          style: TextStyle(
            color: Colors.teal,
            letterSpacing: 1.5,
            fontWeight: FontWeight.bold,
            fontSize: 14.0,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Help'),
      ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Center(
                child: ListView(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 40.0, vertical: 30.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
//                          _buildUsernameTF(),
//                          SizedBox(
//                            height: 10.0,
//                          ),
//                          _buildNextBtn(),
//                          _buildSignWithText(),
//                          _buildSocialBtnRow(),
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.account_circle, size: 80),
                          ),
                          Text('To recover your password please call.',
                              style: TextStyle(fontSize: 18.0)),
                          Divider(),
                          ListTile(
                            leading: CircleAvatar(
                              radius: 18,
                              child: Icon(Icons.call),
                            ),
                            title: Text(
                              '+(255)710 003 901',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
