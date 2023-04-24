import 'package:flutter/material.dart';
import 'package:malango_pod/locator.dart';
import 'package:malango_pod/services/navigation_service.dart';
import 'package:malango_pod/ui/shared/colors.dart';
import 'package:malango_pod/ui/widgets/button/icon_button.dart';
import 'package:malango_pod/ui/widgets/main_pages/home/malango_label.dart';

/// [SearchAppbar] is an appbar widget in searchScreen that has backButton and MalangoLabel widget
class SearchAppbar extends StatelessWidget {
  const SearchAppbar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Container(
      color: green,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ArrowBackIcon(
            color: white,
            size: width * 0.06,
            onTap: () => locator<NavigationService>().goBack(),
          ),
          const MalangoLabel(),
          SizedBox(
            height: width * 0.06,
            width: width * 0.06,
          )
        ],
      ),
    );
  }
}
