import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  final String username;
  final String text;
  final Color widgetColor;
  final bool textBold;
  final int trimLines;
  final bool readMore;
  final bool readLess;
  ExpandableText({
    Key key,
    this.username,
    this.text,
    this.widgetColor = Colors.black,
    this.textBold = false,
    this.trimLines,
    this.readMore = true,
    this.readLess = true,
  }) : super(key: key);

  @override
  ExpandableTextState createState() => ExpandableTextState();
}

class ExpandableTextState extends State<ExpandableText> {
  bool _readMore = true;
  void _onTapLink() {
    setState(() => _readMore = !_readMore);
  }

  @override
  Widget build(BuildContext context) {
    final colorClickableText = Colors.red;
    TextSpan link = widget.readMore
        ? TextSpan(
            text: _readMore
                ? "... read more"
                : widget.readLess
                    ? " read less"
                    : null,
            style: TextStyle(
              color: colorClickableText,
            ),
            recognizer: TapGestureRecognizer()..onTap = _onTapLink)
        : TextSpan(
            text: _readMore ? "...." : null,
            recognizer: TapGestureRecognizer()..onTap = _onTapLink);
    Widget result = LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        assert(constraints.hasBoundedWidth);
        final double maxWidth = constraints.maxWidth;
        // Create a TextSpan with data
        final text = TextSpan(
          text: widget.text,
        );
        // Layout and measure link
        TextPainter textPainter = TextPainter(
          text: link,
          textDirection: TextDirection
              .rtl, //better to pass this from master widget if ltr and rtl both supported
          maxLines: widget.trimLines,
          ellipsis: '...',
        );
        textPainter.layout(minWidth: constraints.minWidth, maxWidth: maxWidth);
        final linkSize = textPainter.size;
        // Layout and measure text
        textPainter.text = text;
        textPainter.layout(minWidth: constraints.minWidth, maxWidth: maxWidth);
        final textSize = textPainter.size;
        // Get the endIndex of data
        int endIndex;
        final pos = textPainter.getPositionForOffset(Offset(
          textSize.width - linkSize.width,
          textSize.height,
        ));
        endIndex = textPainter.getOffsetBefore(pos.offset);

        var textSpan;
        if (textPainter.didExceedMaxLines) {
          textSpan = TextSpan(
            text: _readMore ? widget.text.substring(0, endIndex) : widget.text,
            style: widget.textBold
                ? TextStyle(
                    color: widget.widgetColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                  )
                : TextStyle(
                    color: widget.widgetColor,
                    fontSize: 15.0,
                  ),
            children: <TextSpan>[link],
          );
        } else {
          textSpan = TextSpan(
            text: widget.text,
            style: widget.textBold
                ? TextStyle(
                    color: widget.widgetColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                  )
                : TextStyle(
                    color: widget.widgetColor,
                    fontSize: 15.0,
                  ),
          );
        }
        return RichText(
          softWrap: true,
          overflow: TextOverflow.clip,
          text: TextSpan(children: [
            TextSpan(
              text: widget.username != null
                  ? "@" + widget.username + " "
                  : widget.username,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            textSpan,
          ]),
        );
      },
    );
    return result;
  }
}
