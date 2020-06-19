import 'package:flutter/material.dart';
import 'package:windowshoppi/products/details/details.dart';
import 'package:windowshoppi/routes/fade_transition.dart';

class PostSection extends StatelessWidget {
  final String imageUrl;
  PostSection({Key key, this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      fit: FlexFit.loose,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            FadeRoute(
              widget: Details(imageUrl: imageUrl),
            ),
          );
        },
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
