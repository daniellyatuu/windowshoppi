import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:windowshoppi/models/product.dart';

class SelectCountry extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        var selectedCountry = await showCupertinoModalPopup(
          context: context,
          builder: (context) {
            return Container(
              height: MediaQuery.of(context).size.height / 2,
              alignment: Alignment.bottomCenter,
              child: CupertinoActionSheet(
                title: Text('select country'),
                actions: <Widget>[
                  CupertinoActionSheetAction(
                    onPressed: () {
                      Navigator.of(context).pop({'id': 1, 'name': 'Tanzania'});
                    },
                    isDefaultAction: true,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.check_circle_outline),
                        Text(
                          'Tanzania',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  CupertinoActionSheetAction(
                    onPressed: () {
                      Navigator.of(context).pop({'id': 2, 'name': 'Kenya'});
                    },
                    isDefaultAction: false,
                    child: Text('Kenya'),
                  ),
                ],
                cancelButton: CupertinoActionSheetAction(
                  onPressed: () {
                    Navigator.of(context).pop('close');
                  },
                  child: Text('close'),
                ),
              ),
            );
          },
        );

        print(selectedCountry);
      },
      child: Row(
        children: <Widget>[
          Icon(Icons.location_on),
          Container(
            padding: EdgeInsets.only(right: 10.0),
            child: Text('Tanzania'),
          ),
        ],
      ),
    );
  }
}
