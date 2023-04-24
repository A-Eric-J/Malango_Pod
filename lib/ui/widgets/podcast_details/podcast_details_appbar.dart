import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:malango_pod/locator.dart';
import 'package:malango_pod/services/navigation_service.dart';
import 'package:malango_pod/ui/shared/colors.dart';
import 'package:malango_pod/ui/shared/text.dart';
import 'package:malango_pod/ui/widgets/button/icon_button.dart';
import 'package:malango_pod/ui/widgets/text/text_view.dart';
import 'package:malango_pod/ui/extensions/help_methods.dart';

/// [PodcastDetailsAppbar] is a SliverAppBar that the title of podcast is shown at the center
/// and it has BackButton and ShareButton for sharing this podcast to your friends
class PodcastDetailsAppbar extends StatelessWidget {
  final bool isCollapsed;
  final String title;
  final BuildContext parentContext;

  const PodcastDetailsAppbar({
    Key key,
    this.isCollapsed,
    this.title,
    this.parentContext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return SliverAppBar(
      systemOverlayStyle: SystemUiOverlayStyle.light,
      title: AnimatedOpacity(
        opacity: isCollapsed ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 0),
        child: Center(
          child: TextView(
            text: title,
            color: brandMainColor,
            size: 12,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      leading: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.04),
        child: ArrowBackIcon(
          onTap: () => locator<NavigationService>().goBack(),
          color: brandMainColor,
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.04),
          child: ShareIcon(
            onTap: () => onShare(parentContext, sharePodcastText(title)),
            color: brandMainColor,
          ),
        )
      ],
      backgroundColor: white,
      floating: true,
      pinned: true,
    );
  }
}
