import 'package:flutter/material.dart';
import 'package:malango_pod/ui/shared/colors.dart';
import 'package:malango_pod/ui/shared/text.dart';
import 'package:malango_pod/ui/widgets/button/icon_button.dart';
import 'package:malango_pod/ui/widgets/podcast_html_to_text.dart';
import 'package:malango_pod/ui/widgets/text/text_view.dart';

/// [PodcastDetailsDescription] is for showing podcast description
class PodcastDetailsDescription extends StatelessWidget {
  final String description;

  const PodcastDetailsDescription({Key key, this.description})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(width * 0.04),
          child: Row(
            children: [
              InfoIcon(
                size: width * 0.0533,
                color: green,
              ),
              SizedBox(
                width: width * 0.02,
              ),
              const TextView(
                text: aboutThisPodcastText,
                color: green,
                fontWeight: FontWeight.bold,
                size: 15,
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.04,
          ),
          child: description != null && description.isNotEmpty
              ? PodcastHtmlToText(
                  text: description,
                )
              : const TextView(
                  text: podcastEmptyDescriptionText,
                  color: primaryDark,
                  size: 16,
                  textAlign: TextAlign.justify,
                ),
        ),
      ],
    );
  }
}
