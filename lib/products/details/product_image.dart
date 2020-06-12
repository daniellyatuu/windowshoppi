import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {
  final String imageUrl;
  ProductImage({Key key, this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Hero(
        tag: '1',
        child: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Center(
            child: Image.network(imageUrl),
          ),
        ),
      ),
    );
  }
}
