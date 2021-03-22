import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PeopleToFollowLoader extends StatefulWidget {
  @override
  _PeopleToFollowLoaderState createState() => _PeopleToFollowLoaderState();
}

class _PeopleToFollowLoaderState extends State<PeopleToFollowLoader> {
  Color _baseColor = Colors.grey[400];
  Color _highlightColor = Colors.grey[200];

  List<String> imageList = ['url_1', 'url_2', 'url_3'];

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: _baseColor,
      highlightColor: _highlightColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 15.0,
                        width: MediaQuery.of(context).size.width / 1.8,
                        color: _baseColor,
                      ),
                      SizedBox(
                        height: 2.0,
                      ),
                      Container(
                        height: 15.0,
                        width: MediaQuery.of(context).size.width / 2.5,
                        color: _baseColor,
                      ),
                    ],
                  ),
                ),
                AbsorbPointer(
                  absorbing: true,
                  child: RaisedButton(
                    onPressed: () {},
                    shape: new RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 6,
                  height: MediaQuery.of(context).size.width / 6,
                  child: ClipOval(
                    child: Container(
                      color: _baseColor,
                    ),
                  ),
                ),
                for (String image in imageList)
                  Container(
                    width: MediaQuery.of(context).size.width / 8,
                    height: MediaQuery.of(context).size.width / 8,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 1.0),
                      child: Container(
                        color: _baseColor,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
