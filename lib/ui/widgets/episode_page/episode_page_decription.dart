import 'package:flutter/material.dart';
import 'package:malango_pod/ui/shared/colors.dart';
import 'package:malango_pod/ui/shared/text.dart';
import 'package:malango_pod/ui/widgets/button/icon_button.dart';
import 'package:malango_pod/ui/widgets/podcast_html_to_text.dart';
import 'package:malango_pod/ui/widgets/text/text_view.dart';

/// Episode Description is shown in [EpisodePageDescription] widget
class EpisodePageDescription extends StatelessWidget {
  final String description;

  const EpisodePageDescription({Key key, @required this.description})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
            right: width * 0.05,
            left: width * 0.05,
            bottom: width * 0.05379,
          ),
          child: Row(
            children: [
              InfoIcon(
                size: width * 0.04295,
                color: green,
              ),
              SizedBox(
                width: width * 0.02,
              ),
              const TextView(
                text: aboutThisEpisodeText,
                size: 16,
                fontWeight: FontWeight.bold,
                color: green,
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              right: width * 0.070,
              left: width * 0.070,
              bottom: width * 0.1422),
          child: (description == null || description == '')
              ? const TextView(
                  text: episodeEmptyDescription,
                  size: 16,
                  color: textGray,
                )
              : PodcastHtmlToText(
                  text: description,
                ),
        ),
      ],
    );
  }
}
