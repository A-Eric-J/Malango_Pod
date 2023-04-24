import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:malango_pod/ui/shared/colors.dart';
import 'package:malango_pod/ui/widgets/widget_in_busy_state.dart';

/// When PodcastSliders in HomeScreen are in BusyState we use [PodcastSliderInBusyState]
class PodcastSliderInBusyState extends StatelessWidget {
  const PodcastSliderInBusyState({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: width * 0.01,
      ),
      child: SizedBox(
        height: width * 0.45,
        child: Swiper(
          itemBuilder: (BuildContext context, int index) {
            return WidgetInBusyState(
              width: width * 0.5,
              height: width * 0.3961,
            );
          },
          autoplay: true,
          itemCount: 4,
          pagination: SwiperPagination(
              margin: EdgeInsets.zero,
              builder: SwiperCustomPagination(
                  builder: (BuildContext context, SwiperPluginConfig config) {
                return ConstrainedBox(
                  constraints: BoxConstraints.expand(height: width * 0.0533),
                  child: Align(
                    alignment: Alignment.center,
                    child: DotSwiperPaginationBuilder(
                      color: midGreyColor,
                      activeColor: white,
                      size: MediaQuery.of(context).size.width * 0.015,
                    ).build(context, config),
                  ),
                );
              })),
          control: const SwiperControl(size: 0),
        ),
      ),
    );
  }
}
