import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:windowshoppi/src/create_post/create_post_files.dart';

class RecommendationActionSheet extends StatefulWidget {
  @override
  _RecommendationActionSheetState createState() =>
      _RecommendationActionSheetState();
}

class _RecommendationActionSheetState extends State<RecommendationActionSheet> {
  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      actions: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.recommend),
                  Text(
                    ' Recommendation',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ],
              ),
              Divider(),
              Card(
                elevation: 0.0,
                child: ListTile(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateRecommendPage(
                          name: 'business',
                          recommendationType: 1,
                        ),
                      )),
                  title: Text('Businesses'),
                  subtitle: Text('Recommend business around you.'),
                  trailing: Icon(Icons.keyboard_arrow_right_outlined),
                ),
              ),
              Card(
                elevation: 0.0,
                child: ListTile(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateRecommendPage(
                          name: 'product',
                          recommendationType: 2,
                        ),
                      )),
                  title: Text('Products'),
                  subtitle: Text('Recommend your favorite product.'),
                  trailing: Icon(Icons.keyboard_arrow_right_outlined),
                ),
              ),
              Card(
                elevation: 0.0,
                child: ListTile(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateRecommendPage(
                          name: 'place',
                          recommendationType: 3,
                        ),
                      )),
                  title: Text('Places'),
                  subtitle: Text(
                      'Recommend places to visit in your city and beyond.'),
                  trailing: Icon(Icons.keyboard_arrow_right_outlined),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
