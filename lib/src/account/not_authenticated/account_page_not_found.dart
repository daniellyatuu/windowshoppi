import 'package:flutter/material.dart';

class AccountPageNotFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Card(
        margin: EdgeInsets.symmetric(horizontal: 0.0, vertical: 4.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300], width: 2.0),
                    borderRadius: BorderRadius.circular(8.0),
                    shape: BoxShape.rectangle,
                  ),
                  child: Icon(
                    Icons.account_box,
                    color: Colors.grey[300],
                    size: 70,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Account Not Found',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
