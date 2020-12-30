import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AccountLoader extends StatefulWidget {
  @override
  _AccountLoaderState createState() => _AccountLoaderState();
}

class _AccountLoaderState extends State<AccountLoader> {
  Color _baseColor = Colors.grey[400];

  Color _highlightColor = Colors.grey[200];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Shimmer.fromColors(
          baseColor: _baseColor,
          highlightColor: _highlightColor,
          child: Container(
            color: Colors.white,
            height: 22.0,
            width: MediaQuery.of(context).size.width / 3,
          ),
        ),
        centerTitle: true,
      ),
      body: Card(
        margin: EdgeInsets.symmetric(horizontal: 0.0, vertical: 4.0),
        child: Shimmer.fromColors(
          baseColor: _baseColor,
          highlightColor: _highlightColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        color: _baseColor,
                        borderRadius: BorderRadius.circular(8.0),
                        shape: BoxShape.rectangle,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: (MediaQuery.of(context).size.width / 2) - 40.0,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 2.0),
                      color: _baseColor,
                      height: 17.0,
                    ),
                  ),
                ),
                SizedBox(height: 2.0),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 2.0),
                      color: _baseColor,
                      height: 8.0,
                    ),
                  ),
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: AbsorbPointer(
                            absorbing: true,
                            child: RaisedButton(
                              onPressed: () {},
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        Expanded(
                          child: AbsorbPointer(
                            absorbing: true,
                            child: RaisedButton(
                              onPressed: () {},
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          width: 14.0,
                          height: 12.0,
                          decoration: BoxDecoration(
                            color: _baseColor,
                            borderRadius: BorderRadius.circular(2.0),
                            shape: BoxShape.rectangle,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 7.0),
                          child: Container(
                            alignment: Alignment.centerLeft,
                            width: MediaQuery.of(context).size.width / 3,
                            height: 8.0,
                            color: _baseColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.0),
                  child: Container(
                    height: 8.0,
                    width: MediaQuery.of(context).size.width / 4,
                    color: _baseColor,
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
