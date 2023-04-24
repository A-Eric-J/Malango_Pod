import 'package:malango_pod/const_values/urls.dart';
import 'package:malango_pod/enums/view_state.dart';
import 'package:malango_pod/models/podcast_response.dart';
import 'package:malango_pod/providers/search/search_provider.dart';
import 'package:malango_pod/services/web_service.dart';

class SearchService {
  /// Searching API
  static Future<void> search(WebService webService,SearchProvider searchProvider,{String searchKey}) async {
    searchProvider.setPodcastResponseViewState(ViewState.busy);

   var response = await webService.getFunction(URLs.searchApiUrl(searchKey: searchKey,limitSize: 40));
      if (response.success) {
        var results = PodcastResponse.fromJson(json: response.body);
        searchProvider.setPodcastResponse(results);
        searchProvider.setPodcastResponseViewState(ViewState.ready);
      } else {
        searchProvider.setPodcastResponseViewState(ViewState.failed);
      }
  }
}
