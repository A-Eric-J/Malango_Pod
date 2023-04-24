import 'package:malango_pod/enums/download_state.dart';
import 'package:flutter/foundation.dart';


/// This class presents an Episode of a Podcast
class Episode {

  /// Database ID
  int id;

  /// GUID is a Unique identifier for the episode
  final String guId;


  /// this id that is unique is assigned by download manager when the episode is downloaded
  String episodeDownloadId;

  /// The current downloading state of the episode.
  DownloadState episodeDownloadState;

  /// this parameter is used for storing the progress of episode download
  int episodeDownloadPercentageProgress;

  /// when an episode is going to being downloaded a file name will assigning to it
  String episodeFileName;


  /// when an episode is going to being downloaded it stores in this path
  String episodeFilePath;



  /// the GUID of the podcast of this episode
  String podcastGuId;



  /// The name of the podcast the episode is part of
  String podcastName;

  /// The episode title
  String episodeTitle;

  /// The episode description
  String episodeDescription;
  

  /// The link for the episode from where it is located
  String episodeLink;

  /// the narrator of the episode or the podcast
  String narrator;

  /// the episode publication date.
  DateTime episodePublicationDate;

  /// link of  the episode image
  String episodeImageLink;

  /// link of the thumbnail image of the episode
  String episodeThumbnailImageLink;
  

  /// this parameter is for the season of the podcast and we use it
  /// for episode file naming
  int podcastSeason;

  /// The episode number of the season if available for using in episode file name
  int seasonEpisodeNumber;

  ///  duration of the episode in milliseconds.
  int episodeDuration;

  /// this parameter is used for showing the episode size
  /// to the user if it is available 
  String episodeSize;

  /// when the episode is paused we store the position of the episode 
  /// to know from where we should resume the episode when the user wanted
  /// to resume again
  int episodePosition;


  /// this parameter is for storing the state of episode
  /// if it is favorited in the database
  bool episodeFavorited;

  

  Episode({
    this.id,
    @required this.guId,
    this.episodeDownloadId,
    this.episodeDownloadState = DownloadState.none,
    this.episodeDownloadPercentageProgress = 0,
    this.episodeFileName,
    this.episodeFilePath,
    this.podcastGuId,
    this.podcastName,
    this.episodeTitle,
    this.episodeDescription,
    this.episodeLink,
    this.narrator,
    this.episodePublicationDate,
    this.episodeImageLink,
    this.episodeThumbnailImageLink,
    this.podcastSeason = 0,
    this.seasonEpisodeNumber = 0,
    this.episodeDuration = 0,
    this.episodeSize,
    this.episodePosition = 0,
    this.episodeFavorited
  });

  /// [fromJson] is used for converting  the stored datas
  /// from the database to the object
  static Episode fromJson(Map<String, dynamic> episode) {
    return Episode(
        id: episode['id'] as int,
        guId: episode['guId'] as String,
        episodeDownloadId: episode['episodeDownloadId'] as String,
        episodeDownloadState: downloadState(episode['episodeDownloadState'] as int),
        episodeDownloadPercentageProgress: episode['episodeDownloadPercentageProgress'] as int ?? 0,
        episodeFileName: episode['episodeFileName'] as String,
        episodeFilePath: episode['episodeFilePath'] as String,
        podcastGuId: episode['podcastGuId'] as String,
        podcastName: episode['podcastName'] as String,
        episodeTitle: episode['episodeTitle'] as String,
        episodeDescription: episode['episodeDescription'] as String,
        episodeLink: episode['episodeLink'] as String,
        narrator: episode['narrator'] as String,
        episodePublicationDate: episode['episodePublicationDate'] == null || episode['episodePublicationDate'] == 'null'
            ? DateTime.now()
            : DateTime.fromMillisecondsSinceEpoch(int.parse(episode['episodePublicationDate'] as String)),
        episodeImageLink: episode['episodeImageLink'] as String,
        episodeThumbnailImageLink: episode['episodeThumbnailImageLink'] as String,
        podcastSeason: episode['podcastSeason'] as int ?? 0,
        seasonEpisodeNumber: episode['seasonEpisodeNumber'] as int ?? 0,
        episodeDuration: episode['episodeDuration'] as int ?? 0,
        episodeSize: episode['episodeSize'] as String,
        episodePosition: episode['episodePosition'] as int ?? 0,
        episodeFavorited: episode['episodeFavorited']!= null && (episode['episodeFavorited'] as int) == 1 ? true : false
    );
  }
  /// [toJson] is used for converting the object to storing
  /// in the database
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id' : id,
      'guId': guId,
      'episodeDownloadId': episodeDownloadId,
      'episodeDownloadState': episodeDownloadState.index,
      'episodeDownloadPercentageProgress': episodeDownloadPercentageProgress.toString(),
      'episodeFileName': episodeFileName,
      'episodeFilePath': episodeFilePath,
      'podcastGuId': podcastGuId,
      'podcastName': podcastName,
      'episodeTitle': episodeTitle,
      'episodeDescription': episodeDescription,
      'episodeLink': episodeLink,
      'narrator': narrator,
      'episodePublicationDate': episodePublicationDate?.millisecondsSinceEpoch.toString(),
      'episodeImageLink': episodeImageLink,
      'episodeThumbnailImageLink': episodeThumbnailImageLink,
      'podcastSeason': podcastSeason.toString(),
      'seasonEpisodeNumber': seasonEpisodeNumber.toString(),
      'episodeDuration': episodeDuration.toString(),
      'episodeSize': episodeSize,
      'episodePosition': episodePosition.toString(),
      'episodeFavorited': (episodeFavorited != null && episodeFavorited) ? 1 : 0,
    };
  }

  bool get isEpisodeDownloaded => episodeDownloadPercentageProgress == 100;


}
