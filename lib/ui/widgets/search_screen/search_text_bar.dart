import 'package:flutter/material.dart';
import 'package:malango_pod/const_values/assets.dart';
import 'package:malango_pod/providers/search/search_provider.dart';
import 'package:malango_pod/services/search/search_service.dart';
import 'package:malango_pod/services/web_service.dart';
import 'package:malango_pod/ui/shared/colors.dart';
import 'package:malango_pod/ui/shared/text.dart';
import 'package:malango_pod/ui/widgets/blog.dart';
import 'package:malango_pod/ui/widgets/button/icon_button.dart';
import 'package:malango_pod/ui/widgets/textformfield/textformfield_item/textformfield_item.dart';
import 'package:provider/provider.dart';

/// [SearchTextBar] is a custom widget in searchScreen that has TextFormFieldItem for searching
class SearchTextBar extends StatefulWidget {
  const SearchTextBar({
    Key key,
  }) : super(key: key);

  @override
  State<SearchTextBar> createState() => _SearchTextBarState();
}

class _SearchTextBarState extends State<SearchTextBar> {
  WebService webService;
  var searchController = TextEditingController();
  var clearButtonEnable = false;

  @override
  void initState() {
    webService = Provider.of(context, listen: false);
    searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Consumer<SearchProvider>(builder: (context, searchProvider, child) {
      return Stroke(
          radius: width * 0.012,
          width: width,
          borderWidth: 2,
          borderColor: midGreyColor,
          backgroundColor: searchBarBackgroundColor,
          padding: EdgeInsets.all(width * 0.02),
          innerPadding: EdgeInsets.symmetric(horizontal: width * 0.04),
          child: Row(
            children: <Widget>[
              const ImageAndIconFill(
                path: Assets.search,
                isSvg: true,
              ),
              Expanded(
                child: TextFormFieldItem(
                  textController: searchController,
                  labelText: searchLabelText,
                  hasBorder: false,
                  hasLabel: false,
                  hintText: searchYourLovelyPodcastText,
                  radius: width * 0.0266,
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      setState(() {
                        clearButtonEnable = true;
                      });
                    } else {
                      searchProvider.clean();
                      setState(() {
                        clearButtonEnable = false;
                      });
                    }
                  },
                  onSubmitted: (value) {
                    SearchService.search(webService, searchProvider,
                        searchKey: value);
                  },
                ),
              ),
              if (clearButtonEnable)
                ClearOrCloseIcon(
                  size: width * 0.05,
                  onTap: () {
                    searchController.clear();
                    searchProvider.clean();
                    setState(() {
                      clearButtonEnable = false;
                    });
                  },
                )
            ],
          ));
    });
  }
}
