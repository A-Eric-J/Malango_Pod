import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:malango_pod/const_values/assets.dart';
import 'package:malango_pod/ui/shared/colors.dart';
import 'package:url_launcher/url_launcher.dart';

/// [PodcastHtmlToText] is for converting html format to text
class PodcastHtmlToText extends StatelessWidget {
  final String text;

  const PodcastHtmlToText({
    Key key,
    @required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Html(
      data: text ?? '',
      style: {
        html: Style(
            fontFamily: Assets.robotoFont,
            color: textGray,
            fontSize: FontSize.large,
            letterSpacing: 0,
            fontWeight: FontWeight.w700,
            textAlign: TextAlign.justify)
      },
      onLinkTap: (tagUrl, _, __, ___) =>
          canLaunchUrl(Uri.parse(tagUrl)).then((value) => launchUrl(
                Uri.parse(tagUrl),
                mode: LaunchMode.externalApplication,
              )),
    );
  }
}
