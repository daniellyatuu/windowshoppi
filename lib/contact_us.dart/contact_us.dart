import 'package:flutter/material.dart';

class ContactUs extends StatefulWidget {
  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  Widget _contactUsCard(_icon, _text) {
    return Card(
      margin: EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 30.0,
      ),
      child: Padding(
        padding: EdgeInsets.all(0),
        child: ListTile(
          leading: Icon(
            _icon,
            color: Colors.teal,
          ),
          title: Text(
            _text,
            style: TextStyle(
              fontFamily: 'SourceSansPro',
              color: Colors.teal.shade900,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Us'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: 50.0,
                backgroundImage: AssetImage('images/logo/logo_200_200.png'),
              ),
              Text(
                'windowshoppi',
                style: TextStyle(
                  fontSize: 35.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Itim',
                ),
              ),
              Text(
                'the smarter way',
                style: TextStyle(
                  fontFamily: 'SourceSansPro',
                  color: Colors.red,
                  fontSize: 12.0,
                  letterSpacing: 2.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 20.0,
                width: 150,
                child: Divider(
                  color: Colors.teal.shade100,
                ),
              ),
              _contactUsCard(Icons.phone, '+(255)710 003 901'),
            ],
          ),
        ),
      ),
    );
  }
}
