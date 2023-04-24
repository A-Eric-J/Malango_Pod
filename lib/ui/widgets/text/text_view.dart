import 'package:malango_pod/const_values/assets.dart';
import 'package:malango_pod/ui/shared/colors.dart';
import 'package:malango_pod/ui/shared/text_style.dart';
import 'package:flutter/material.dart';

/// [TextView] is a custom widget of Text widget that is using in this app
class TextView extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final TextAlign textAlign;
  final TextOverflow overflow;
  final double weightOfParent;
  final int maxLines;
  final double size;
  final Color color;
  final FontWeight fontWeight;
  final bool hasUnderLine;
  final TextDirection direction;
  final TextDirection textDirection;

  const TextView(
      {Key key,
      @required this.text,
      this.onTap,
      this.textAlign,
      this.overflow,
      this.weightOfParent,
      this.maxLines,
      @required this.size,
      this.color,
      this.fontWeight,
      this.hasUnderLine = false,
      this.direction,
      this.textDirection})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var mainSize = (size / mainWidthSize) * width;
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: onTap,
      child: SizedBox(
        width: weightOfParent,
        child: Directionality(
          textDirection: direction ?? TextDirection.ltr,
          child: Text(
            text ?? '',
            textDirection: textDirection ?? TextDirection.ltr,
            style: fontWeight != null
                ? robotoBoldStyle(mainSize, color ?? primaryDark, fontWeight)
                : hasUnderLine
                    ? robotoUnderLineStyle(mainSize, color ?? primaryDark)
                    : robotoNormalStyle(mainSize, color ?? primaryDark),
            textAlign: textAlign,
            overflow: overflow,
            maxLines: maxLines,
          ),
        ),
      ),
    );
  }
}

class TextViewWithStaticSize extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final TextAlign textAlign;
  final TextOverflow overflow;
  final double weightOfParent;
  final int maxLine;
  final double size;
  final Color color;
  final FontWeight fontWeight;
  final bool hasUnderLine;
  final TextDirection direction;
  final TextDirection textDirection;

  const TextViewWithStaticSize(
      {Key key,
      @required this.text,
      this.onTap,
      this.textAlign,
      this.overflow,
      this.weightOfParent,
      this.maxLine,
      this.size = 12,
      this.color,
      this.fontWeight,
      this.hasUnderLine = false,
      this.direction,
      this.textDirection})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: onTap,
      child: SizedBox(
        width: weightOfParent,
        child: Directionality(
          textDirection: direction ?? TextDirection.ltr,
          child: Text(
            text ?? '',
            textDirection: textDirection ?? TextDirection.ltr,
            style: fontWeight != null
                ? robotoBoldStyle(size, color ?? primaryDark, fontWeight)
                : hasUnderLine
                    ? robotoUnderLineStyle(size, color ?? primaryDark)
                    : robotoNormalStyle(size, color ?? primaryDark),
            textAlign: textAlign,
            overflow: overflow,
            maxLines: maxLine,
          ),
        ),
      ),
    );
  }
}
