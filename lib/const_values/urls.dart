import 'package:malango_pod/const_values/config.dart';

/// URLs refers to all the endpoints that are using in MalangoPod
class URLs {
  static String searchApiUrl({String searchKey, int limitSize}) =>
      '${baseUrl}search${searchKey != null && searchKey.isNotEmpty ? '?term=${Uri.encodeComponent(searchKey)}' : ''}${limitSize != null && limitSize != 0 ? '&limit=$limitSize' : ''}&media=podcast&entity=podcast';

  static String homePopularPodcastUrl(int limit) =>
      '${baseUrl}rss/toppodcasts/limit=$limit/json';

  /// genre=1545 refers to Sport
  static String homeSportPodcastUrl(int limit) =>
      '${baseUrl}rss/toppodcasts/limit=$limit/genre=1545/json';

  /// these are other genre ids and you can replace them:
  /// Business : 1321
  /// Comedy : 1303
  /// Education : 1304
  /// News: 1311
  /// You can find the full list of genre codes on the iTunes Store Genre IDs page: https://affiliate.itunes.apple.com/resources/documentation/genre-mapping/

  static String lookUpPodcastUrl(String id) => '$baseUrl/lookup?id=$id';
}
