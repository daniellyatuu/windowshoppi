import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PageAccount extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('account name'),
      ),
      body: ListView(
        children: <Widget>[
          AccountProfile(),
          AccountCommunication(),
          AccountDescription(),
          Divider(),
          ProductViewSwitch(),
          AccountProducts(),
        ],
      ),
    );
  }
}

class AccountProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 28.0,
        child: CircleAvatar(
          radius: 25.0,
          backgroundColor: Colors.white,
          backgroundImage: AssetImage('images/shop.jpg'),
        ),
      ),
      title: Text(
        'account name',
        style: Theme.of(context).textTheme.headline,
      ),
      subtitle: Row(
        children: <Widget>[
          Icon(
            Icons.location_on,
            size: 18.0,
          ),
          Text(
            'location',
            style: Theme.of(context).textTheme.subhead,
          ),
        ],
      ),
    );
  }
}

class AccountCommunication extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      margin: EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: OutlineButton(
              onPressed: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FaIcon(FontAwesomeIcons.phoneSquareAlt),
                  Text(' call'),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 10.0,
          ),
          Expanded(
            child: OutlineButton(
              onPressed: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FaIcon(FontAwesomeIcons.whatsappSquare),
                  Text(' chart'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AccountDescription extends StatefulWidget {
  @override
  _AccountDescriptionState createState() => _AccountDescriptionState();
}

class _AccountDescriptionState extends State<AccountDescription> {
  String description =
      'Account description in here Account description in here Account description in here Account description in here';
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: Text(
        description,
        textAlign: TextAlign.justify,
      ),
    );
  }
}

class ProductViewSwitch extends StatefulWidget {
  @override
  _ProductViewSwitchState createState() => _ProductViewSwitchState();
}

class _ProductViewSwitchState extends State<ProductViewSwitch> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            color: Colors.black87,
            child: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.grid_on,
                color: Colors.white,
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.list),
          ),
        ],
      ),
    );
  }
}

class AccountProducts extends StatefulWidget {
  @override
  _AccountProductsState createState() => _AccountProductsState();
}

class _AccountProductsState extends State<AccountProducts> {
  num countValue = 2;

  num aspectWidth = 2;

  num aspectHeight = 1;

  List<String> gridItems = [
    'One',
    'Two',
    'Three',
    'Four',
    'Five',
    'Six',
    'Seven',
    'Eight',
    'Nine',
    'Ten',
    'Eleven',
    'Twelve',
    'Thirteen',
    'Fourteen',
    'Fifteen',
    'Sixteen',
    'Seventeen',
    'Eighteen',
    'Nineteen',
    'Twenty'
  ];

  changeMode() {
    if (countValue == 2) {
      setState(() {
        countValue = 1;
        aspectWidth = 3;
        aspectHeight = 1;
      });
    } else {
      setState(() {
        countValue = 2;
        aspectWidth = 2;
        aspectHeight = 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1000,
      padding: EdgeInsets.all(16.0),
      child: GridView.count(
        crossAxisCount: countValue,
        childAspectRatio: (aspectWidth / aspectHeight),
        children: List.generate(100, (index) {
          return Center(
            child: Text('product $index'),
          );
        }),
      ),
    );
  }
}

//ListView(
//children: <Widget>[
//AccountProfile(),
//AccountCommunication(),
//AccountDescription(),
//Divider(),
//ProductViewSwitch(),
//AccountProducts(),
//],
//),
