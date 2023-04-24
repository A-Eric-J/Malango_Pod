import 'package:flutter/material.dart';
import 'package:malango_pod/ui/shared/colors.dart';
import 'package:malango_pod/ui/widgets/blog.dart';
import 'package:malango_pod/ui/widgets/widget_in_busy_state.dart';

/// When the Podcasts of HomeScreen are in Busy state for getting their responses [HomePodcastItemInBusyState] is shown instead of HomePodcastItem
class HomePodcastItemInBusyState extends StatefulWidget {
  const HomePodcastItemInBusyState({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomePodcastItemInBusyState();
  }
}

class _HomePodcastItemInBusyState extends State<HomePodcastItemInBusyState> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var widthImage = width * 0.3961;
    return Stroke(
      radius: width * 0.012,
      padding: EdgeInsets.symmetric(horizontal: width * 0.0145),
      backgroundColor: white,
      width: (width / 3) - (width * 0.0255),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Expanded(
            child: WidgetInBusyState(),
          ),
          SizedBox(
            height: width * 0.02,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WidgetInBusyState(
                width: (widthImage * 2) / 3,
                height: width * 0.025,
                radius: width * 0.04,
              ),
              SizedBox(
                height: width * 0.01,
              ),
              WidgetInBusyState(
                width: (widthImage * 1.5) / 3,
                height: width * 0.015,
                radius: width * 0.04,
              ),
            ],
          )
        ],
      ),
    );
  }
}
