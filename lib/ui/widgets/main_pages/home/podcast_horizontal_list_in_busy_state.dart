import 'package:flutter/material.dart';
import 'package:malango_pod/ui/shared/colors.dart';
import 'package:malango_pod/ui/widgets/blog.dart';
import 'package:malango_pod/ui/widgets/main_pages/home/home_podcast_item_in_busy_state.dart';
import 'package:malango_pod/ui/widgets/text/text_view.dart';

/// [PodcastHorizontalListInBusyState] is list of popular and sport podcasts of HomeScreen in busy state
class PodcastHorizontalListInBusyState extends StatelessWidget {
  final String title;

  const PodcastHorizontalListInBusyState({Key key, @required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Stroke(
      radius: width * 0.012,
      backgroundColor: white,
      padding: EdgeInsets.only(
        left: width * 0.0090,
        right: width * 0.0090,
        top: width * 0.015,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: width * 0.0110,
                right: width * 0.020,
                top: width * 0.025,
                bottom: width * 0.01),
            child: TextView(
              text: title,
              maxLines: 1,
              color: brandMainColor,
              fontWeight: FontWeight.bold,
              size: 14,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: width * 0.015,
                right: width * 0.015,
                top: width * 0.03,
                bottom: width * 0.02),
            child: SizedBox(
              height: width * 0.45,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
                padding: const EdgeInsets.all(0.0),
                itemCount: 10,
                itemBuilder: (BuildContext context, int index) {
                  return const HomePodcastItemInBusyState();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
