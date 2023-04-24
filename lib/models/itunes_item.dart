class ItunesItem {
  /// GUID is a Unique identifier for the episode
  final String itunesGuId;

  ///  track name.
  final String itunesTrackName;

  ///  name of the artist.
  final String itunesArtistName;

  /// rss feed link of podcast
  final String rssFeedLink;

  /// itunes best resolution image.
  final String itunesImageLink;

  /// itunes image link in 30x30 size.
  final String itunesImageLink30In30;

  /// itunes image link in 60x60 size.
  /// and we prefer to use this size for podcast thumbnail
  final String itunesImageLink60In60;

  /// itunes image link in 100x100 size.
  final String itunesImageLink100In100;

  /// itunes image link in 600x600 size.
  final String itunesImageLink600In600;

  ItunesItem({
    this.itunesGuId,
    this.itunesTrackName,
    this.itunesArtistName,
    this.rssFeedLink,
    this.itunesImageLink,
    this.itunesImageLink30In30,
    this.itunesImageLink60In60,
    this.itunesImageLink100In100,
    this.itunesImageLink600In600,
  });

  /// [fromJson] is for making a podcast object from itunes object
  factory ItunesItem.fromJson({
    Map<String, dynamic> json,
  }) {
    return ItunesItem(
      itunesGuId: json['guid'] as String,
      itunesTrackName: json['trackName'] as String,
      itunesArtistName: json['artistName'] as String,
      rssFeedLink: json['feedUrl'] as String,
      itunesImageLink: json['artworkUrl'] as String,
      itunesImageLink30In30: json['artworkUrl30'] as String,
      itunesImageLink60In60: json['artworkUrl60'] as String,
      itunesImageLink100In100: json['artworkUrl100'] as String,
      itunesImageLink600In600: json['artworkUrl600'] as String,
    );
  }
}
