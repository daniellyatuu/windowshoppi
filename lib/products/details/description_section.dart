import 'package:flutter/material.dart';

class DescriptionSection extends StatefulWidget {
  @override
  _DescriptionSectionState createState() => _DescriptionSectionState();
}

class _DescriptionSectionState extends State<DescriptionSection> {
  String description =
      'product desction in here product product desction in here product d product desction in here product dproduct desction in  product desction in here product d product desction in here product d here product d  desction in here product desction in hereproduct desction in here product desction in hereproduct desction in hereproduct desction in here product desction in here';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      child: Text(
        description,
        textAlign: TextAlign.justify,
      ),
    );
  }
}
