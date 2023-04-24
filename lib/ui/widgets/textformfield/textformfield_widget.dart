import 'package:flutter/material.dart';
import 'package:malango_pod/ui/shared/colors.dart';
import 'package:malango_pod/ui/shared/text.dart';
import 'package:malango_pod/ui/shared/text_style.dart';
import 'package:malango_pod/ui/widgets/text/text_view.dart';

/// [TextFormFieldWidget] is a custom widget of TextFormField widget that is using in this app
class TextFormFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final void Function(String) onChanged;
  final void Function(String) onSubmitted;
  final int maxLength;
  final int maxLines;
  final int minLines;
  final String initialText;
  final bool enable;
  final Color textColor;
  final double hintSize;
  final double textSize;
  final bool hasLabel;
  final bool filled;
  final Color backgroundColor;
  final VoidCallback onTap;
  final bool hasBorder;
  final TextAlign textAlign;
  final TextDirection textDirection;
  final double radius;

  const TextFormFieldWidget({
    Key key,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.maxLength,
    this.maxLines,
    this.initialText,
    this.enable = true,
    this.textColor = black,
    this.textSize = 14,
    this.labelText = '',
    this.hintSize,
    this.hasLabel,
    this.filled,
    this.backgroundColor,
    this.onTap,
    this.minLines,
    this.hasBorder = true,
    this.textAlign = TextAlign.right,
    this.textDirection,
    this.radius,
  }) : super(key: key);

  @override
  State<TextFormFieldWidget> createState() => _TextFormFieldWidgetState();
}

class _TextFormFieldWidgetState extends State<TextFormFieldWidget> {
  bool visibilityRemoveIconAsSuffix = false;
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Directionality(
      textDirection: widget.textDirection ?? TextDirection.ltr,
      child: InkWell(
        highlightColor: transparent,
        splashColor: transparent,
        onTap: widget.onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.hasLabel)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextView(
                      text: widget.labelText ?? '',
                      size: 12,
                      color: midGreyColor),
                  SizedBox(
                    height: width * 0.0133,
                  ),
                ],
              ),
            TextFormField(
              controller: widget.controller,
              initialValue: widget.initialText,
              maxLines: widget.maxLines,
              minLines: widget.minLines,
              cursorHeight: widget.textSize,
              maxLength: widget.maxLength,
              enabled: widget.enable,
              textAlign: widget.textAlign ?? TextAlign.left,
              keyboardType: keyboardType(),
              textAlignVertical: TextAlignVertical.center,
              textInputAction: textInputAction(),
              style: robotoNormalStyle(widget.textSize, widget.textColor),
              decoration: InputDecoration(
                fillColor: widget.backgroundColor,
                filled: widget.filled,
                counterText: '',
                contentPadding: EdgeInsets.symmetric(
                    horizontal: width * 0.0533, vertical: width * 0.0266),
                border: InputBorder.none,
                focusedErrorBorder: outlineInputBorder(width),
                focusedBorder: outlineInputBorder(width),
                disabledBorder: outlineInputBorder(width),
                enabledBorder: outlineInputBorder(width),
                hintText: hintText() ?? '',
                hintStyle: robotoNormalStyle(14, greyColor),
              ),
              cursorColor: primaryDark,
              onChanged: (value) {
                setState(() {
                  if (widget.onChanged != null) {
                    widget.onChanged(value);
                  }
                });
              },
              onFieldSubmitted: (value) {
                if (widget.onSubmitted != null) {
                  widget.onSubmitted(value);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  InputBorder outlineInputBorder(double width) {
    if (widget.hasBorder != null && widget.hasBorder) {
      return OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.radius ?? width * 0.008),
          borderSide: const BorderSide(color: greyColor, width: 2));
    } else {
      return OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.radius ?? 0),
          borderSide: const BorderSide(color: transparent, width: 0));
    }
  }

  TextInputType keyboardType() {
    switch (widget.labelText) {
      case searchLabelText:
        return TextInputType.text;

      /// if you had any other types you can add here
    }
    return TextInputType.text;
  }

  String hintText() {
    switch (widget.labelText) {
      case searchLabelText:
        return searchLabelHintText;

      /// if you had any other labels you can add here
    }
    return '';
  }

  TextInputAction textInputAction() {
    switch (widget.labelText) {
      case searchLabelText:
        return TextInputAction.search;

      /// if you had any other types you can add here
    }
    return TextInputAction.go;
  }
}
