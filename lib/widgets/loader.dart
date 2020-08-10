import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class InitLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 22,
        width: 22,
        child: CircularProgressIndicator(strokeWidth: 2.0),
      ),
    );
  }
}

class Loader1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300],
        highlightColor: Colors.grey[200],
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
        ),
      ),
    );
  }
}

class Loader2 extends StatefulWidget {
  @override
  _Loader2State createState() => _Loader2State();
}

class _Loader2State extends State<Loader2> {
  Color _baseColor = Colors.grey[300];
  Color _highlightColor = Colors.grey[200];

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 0.0, vertical: 4.0),
      child: Shimmer.fromColors(
        baseColor: _baseColor,
        highlightColor: _highlightColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
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
                          color: _baseColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 3,
                            child: Container(
                              margin: EdgeInsets.only(bottom: 2.0),
                              color: _baseColor,
                              height: 10.0,
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2,
                            child: Container(
                              margin: EdgeInsets.only(top: 2.0),
                              color: _baseColor,
                              height: 10.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    height: 37.0,
                    margin: EdgeInsets.only(top: 2.0),
                    decoration: BoxDecoration(
                      color: _baseColor,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 35.0),
                  ),
                ],
              ),
            ),
            Container(
              height: 200.0,
              color: _baseColor,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          CircleAvatar(
//                            backgroundColor: Colors.blue,
                            radius: 15.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 2.0),
                            child: Container(
                              color: _baseColor,
                              height: 10.0,
                              child: Text('call'),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 15.0,
                      ),
                      Column(
                        children: <Widget>[
                          CircleAvatar(
//                            backgroundColor: Colors.blue,
                            radius: 15.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 2.0),
                            child: Container(
                              color: _baseColor,
                              height: 10.0,
                              child: Text('chart'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  RaisedButton(
                    color: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    onPressed: () async {},
                    child: Row(
                      children: <Widget>[
                        Text(
                          ' share now',
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 13.0),
              child: Container(
                margin: EdgeInsets.only(bottom: 10.0),
                color: _baseColor,
                height: 10.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Loader3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey[300],
        ),
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300],
        highlightColor: Colors.grey[200],
        child: Container(
          color: Colors.grey,
        ),
      ),
    );
  }
}

class Loader4 extends StatefulWidget {
  @override
  _Loader4State createState() => _Loader4State();
}

class _Loader4State extends State<Loader4> {
  Color _baseColor = Colors.grey[300];
  Color _highlightColor = Colors.grey[200];

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Shimmer.fromColors(
        baseColor: _baseColor,
        highlightColor: _highlightColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
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
                          color: _baseColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 3,
                            child: Container(
                              margin: EdgeInsets.only(bottom: 2.0),
                              color: _baseColor,
                              height: 10.0,
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2,
                            child: Container(
                              margin: EdgeInsets.only(top: 2.0),
                              color: _baseColor,
                              height: 10.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.more_vert),
                  ),
                ],
              ),
            ),
            Container(
              height: 200.0,
              color: _baseColor,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[],
                  ),
                  RaisedButton(
                    color: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    onPressed: () async {},
                    child: Row(
                      children: <Widget>[
                        Text(
                          ' share now',
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 13.0),
              child: Container(
                margin: EdgeInsets.only(bottom: 10.0),
                color: _baseColor,
                height: 10.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
