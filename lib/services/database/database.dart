import 'dart:async';
import 'dart:developer';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:malango_pod/enums/download_state.dart';
import 'package:malango_pod/models/episode.dart';
import 'package:malango_pod/models/podcast.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sqflite/sqflite.dart';

class MalangoDatabase {
  MalangoDatabase._();

  static final MalangoDatabase db = MalangoDatabase._();
  Database _database;
  int id_;

  /// in some cases like updating the episode or deleting or etc
  /// we should notify PodcastProvider and EpisodeProvider
  /// to do updates tasks about episodes for UI
  final _episodeNotifier = BehaviorSubject<Episode>();

  Stream<Episode> get episodeNotifier => _episodeNotifier.stream;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initTables();
    return _database;
  }

  /// initializing tables of database
  Future<Database> initTables() async {
    var documentsDirectory = await getApplicationDocumentsDirectory();
    var path = join(documentsDirectory.path, 'Malango.db');
    return await openDatabase(path,
        version: 1,
        onOpen: (db) {},
        onCreate: (db, version) => _onCreateTable(db));
  }

  static void _onCreateTable(Database db) {
    /// Podcast Table
    db.execute('CREATE TABLE Podcast ('
        'id INTEGER PRIMARY KEY,'
        'guId TEXT,'
        'rssFeedLink TEXT,'
        'podcastTitle TEXT,'
        'podcastDescription TEXT,'
        'podcastImageLink TEXT,'
        'podcastThumbnailImageLink TEXT,'
        'podcastOwner TEXT,'
        'podcastSubscribed BIT,'
        'podcastSubscribedDate TEXT'
        ')');

    /// Episode Table
    db.execute('CREATE TABLE Episode ('
        'id INTEGER PRIMARY KEY,'
        'guId TEXT,'
        'episodeDownloadId TEXT,'
        'episodeDownloadState INTEGER,'
        'episodeDownloadPercentageProgress INTEGER,'
        'episodeFileName TEXT,'
        'episodeFilePath TEXT,'
        'podcastGuId TEXT,'
        'podcastName TEXT,'
        'episodeTitle TEXT,'
        'episodeDescription TEXT,'
        'episodeLink TEXT,'
        'narrator TEXT,'
        'episodePublicationDate TEXT,'
        'episodeImageLink TEXT,'
        'episodeThumbnailImageLink TEXT,'
        'podcastSeason INTEGER,'
        'seasonEpisodeNumber INTEGER,'
        'episodeDuration INTEGER,'
        'episodeSize TEXT,'
        'episodePosition INTEGER,'
        'episodeFavorited BIT'
        ')');
  }

  /// *** Insert

  Future<int> insertPodcast(Podcast newPodcast) async {
    final db = await database;

    /// getting the biggest id in the table
    var table = await db.rawQuery('SELECT MAX(id)+1 as id FROM Podcast');
    dynamic id = table.first['id'];

    /// inserting to the table using the new id
    var raw = await db.rawInsert(
        'INSERT Into Podcast (id,guId,rssFeedLink,podcastTitle,podcastDescription'
        ',podcastImageLink,podcastThumbnailImageLink,podcastOwner,podcastSubscribed,podcastSubscribedDate)'
        ' VALUES (?,?,?,?,?,?,?,?,?,?)',
        <dynamic>[
          id,
          newPodcast.guId,
          newPodcast.rssFeedLink,
          newPodcast.podcastTitle,
          newPodcast.podcastDescription,
          newPodcast.podcastImageLink,
          newPodcast.podcastThumbnailImageLink,
          newPodcast.podcastOwner,
          newPodcast.podcastSubscribed,
          newPodcast.podcastSubscribedDate.millisecondsSinceEpoch.toString()
        ]);
    return raw;
  }

  Future<int> insertEpisode(Episode newEpisode) async {
    log('downloadState  ${newEpisode.episodeDownloadState.index}  ${newEpisode.episodeDownloadState}');
    final db = await database;

    /// getting the biggest id in the table
    var table = await db.rawQuery('SELECT MAX(id)+1 as id FROM Episode');
    dynamic id = table.first['id'];

    /// inserting to the table using the new id
    var raw = await db.rawInsert(
        'INSERT Into Episode (id,guId,episodeDownloadId,episodeDownloadState,episodeDownloadPercentageProgress,episodeFileName'
        ',episodeFilePath,podcastGuId,podcastName,episodeTitle,episodeDescription,episodeLink'
        ',narrator,episodePublicationDate,episodeImageLink,episodeThumbnailImageLink,podcastSeason,seasonEpisodeNumber,episodeDuration,episodeSize'
        ',episodePosition,episodeFavorited'
        ')'
        ' VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        <dynamic>[
          id,
          newEpisode.guId,
          newEpisode.episodeDownloadId,
          newEpisode.episodeDownloadState.index,
          newEpisode.episodeDownloadPercentageProgress,
          newEpisode.episodeFileName,
          newEpisode.episodeFilePath,
          newEpisode.podcastGuId,
          newEpisode.podcastName,
          newEpisode.episodeTitle,
          newEpisode.episodeDescription,
          newEpisode.episodeLink,
          newEpisode.narrator,
          newEpisode.episodePublicationDate.millisecondsSinceEpoch.toString(),
          newEpisode.episodeImageLink,
          newEpisode.episodeThumbnailImageLink,
          newEpisode.podcastSeason,
          newEpisode.seasonEpisodeNumber,
          newEpisode.episodeDuration,
          newEpisode.episodeSize,
          newEpisode.episodePosition,
          newEpisode.episodeFavorited,
        ]);
    return raw;
  }

  /// *** Delete
  Future<int> deletePodcast(Podcast newPodcast) async {
    final db = await database;
    return db.delete('Podcast',
        where: 'guId = ?', whereArgs: <dynamic>[newPodcast.guId]);
  }

  Future<int> deleteEpisode(int id) async {
    final db = await database;
    return db.delete('Episode', where: 'id = ?', whereArgs: <dynamic>[id]);
  }

  /// *** Update

  Future<int> updatePodcast(Podcast newPodcast) async {
    log('updatePodcast in database');
    final db = await database;
    var res = await db.update('Podcast', newPodcast.toJson(),
        where: 'id = ?', whereArgs: <dynamic>[newPodcast.id]);
    return res;
  }

  Future<int> updateEpisode(Episode newEpisode) async {
    log('downloadState  ${newEpisode.episodeDownloadState.index}  ${newEpisode.episodeDownloadState} id: ${newEpisode.id} episodeFavorited  ${newEpisode.episodeFavorited}');
    final db = await database;
    var res = await db.update('Episode', newEpisode.toJson(),
        where: 'id = ?', whereArgs: <dynamic>[newEpisode.id]);

    return res;
  }

  /// *** Queries of Podcast
  Future<Podcast> findPodcastById(int id) async {
    final db = await database;
    var res =
        await db.query('Podcast', where: 'id = ?', whereArgs: <dynamic>[id]);
    return res.isNotEmpty ? Podcast.fromJson(res.first) : null;
  }

  Future<Podcast> findPodcastByGuid(String guId) async {
    final db = await database;
    var res = await db
        .query('Podcast', where: 'guId = ?', whereArgs: <dynamic>[guId]);
    Podcast podcast = res.isNotEmpty ? Podcast.fromJson(res.first) : null;
    return podcast;
  }

  Future<Podcast> subscribePodcast(Podcast newPodcast) async {
    final db = await database;
    log('guId: ${newPodcast.guId} ${newPodcast.podcastTitle}');
    String guId = newPodcast.guId;

    var podcast = await db
        .query('Podcast', where: 'guId = ?', whereArgs: <dynamic>[guId]);

    if (podcast.isEmpty) {
      newPodcast.podcastSubscribed = true;
      newPodcast.podcastSubscribedDate = DateTime.now();
      await insertPodcast(newPodcast);
      return newPodcast;
    } else {
      Podcast podcast_ =
          podcast.isNotEmpty ? Podcast.fromJson(podcast.first) : null;
      podcast_.podcastSubscribed = true;
      podcast_.podcastSubscribedDate = DateTime.now();
      await updatePodcast(podcast_);
      return podcast_;
    }
  }

  Future<int> unSubscribePodcast(Podcast deletePodcast_) async {
    return await deletePodcast(deletePodcast_);
  }

  Future<List<Podcast>> subscriptions() async {
    final db = await database;
    var podcasts = await db.query('Podcast');
    List<Podcast> list = podcasts.isNotEmpty
        ? podcasts.map((map) => Podcast.fromJson(map)).toList()
        : [];
    return list;
  }

  /// *** Queries of Episode
  Future<Episode> findEpisodeById(int id) async {
    final db = await database;
    var episode =
        await db.query('Episode', where: 'id = ?', whereArgs: <dynamic>[id]);
    return episode.isNotEmpty ? Episode.fromJson(episode.first) : null;
  }

  Future<Episode> findEpisodeByGuid(String guId) async {
    final db = await database;

    var episode = await db
        .query('Episode', where: 'guId = ?', whereArgs: <dynamic>[guId]);
    return episode.isNotEmpty ? Episode.fromJson(episode.first) : null;
  }

  Future<List<Episode>> findEpisodesByPodcastGuid(String podcastGuId) async {
    final db = await database;
    var episodes = await db.query('Episode',
        where: 'podcastGuId = ?', whereArgs: <dynamic>[podcastGuId]);
    List<Episode> list = episodes.isNotEmpty
        ? episodes.map((map) => Episode.fromJson(map)).toList()
        : [];

    return list;
  }

  Future<Episode> findEpisodeByDownloadId(String episodeDownloadId) async {
    final db = await database;
    var episode = await db.query('Episode',
        where: 'episodeDownloadId = ?',
        whereArgs: <dynamic>[episodeDownloadId]);
    return episode.isNotEmpty ? Episode.fromJson(episode.first) : null;
  }

  Future<Episode> saveEpisode(Episode newEpisode) async {
    final db = await database;
    var episode = await db.query('Episode',
        where: 'guId = ?', whereArgs: <dynamic>[(newEpisode.guId)]);
    if (episode.isEmpty) {
      id_ = await insertEpisode(newEpisode);
      _episodeNotifier.add(newEpisode);
      return newEpisode;
    } else {
      Episode episode_ =
          episode.isNotEmpty ? Episode.fromJson(episode.first) : null;
      newEpisode.id = episode_.id;
      await updateEpisode(newEpisode);
      _episodeNotifier.add(newEpisode);
      return newEpisode;
    }
  }

  Future<int> deleteDownloadedEpisode(Episode newEpisode) async {
    final db = await database;

    var episode = await db.query('Episode',
        where: 'guId = ?', whereArgs: <dynamic>[(newEpisode.guId)]);
    Episode episode_ =
        episode.isNotEmpty ? Episode.fromJson(episode.first) : null;

    if (episode_ != null) {
      newEpisode.id = episode_.id;

      if (episode_.episodeFavorited == false) {
        db.delete('Episode',
            where: 'id = ?', whereArgs: <dynamic>[episode_.id]);
        _episodeNotifier.add(newEpisode);
      } else {
        newEpisode.episodeDownloadState = DownloadState.none;
        newEpisode.episodeDownloadPercentageProgress = 0;
        await updateEpisode(newEpisode);
        _episodeNotifier.add(newEpisode);
      }
    }
    return 0;
  }

  Future<List<Episode>> findDownloads() async {
    final db = await database;
    var episodes = await db.query('Episode',
        where: 'episodeDownloadPercentageProgress = ?',
        whereArgs: <dynamic>[100]);

    List<Episode> list = episodes.isNotEmpty
        ? episodes.map((map) => Episode.fromJson(map)).toList()
        : [];
    return list;
  }

  Future<Episode> favoriteEpisode(Episode newEpisode) async {
    final db = await database;
    var episode = await db.query('Episode',
        where: 'guId = ?', whereArgs: <dynamic>[(newEpisode.guId)]);
    if (episode.isEmpty) {
      newEpisode.episodeFavorited = true;
      id_ = await insertEpisode(newEpisode);
      _episodeNotifier.add(newEpisode);
      return newEpisode;
    } else {
      Episode episode_ =
          episode.isNotEmpty ? Episode.fromJson(episode.first) : null;
      newEpisode.id = episode_.id;
      newEpisode.episodeFavorited = true;
      await updateEpisode(newEpisode);
      _episodeNotifier.add(newEpisode);
      return newEpisode;
    }
  }

  Future<int> unFavoriteEpisode(Episode newEpisode) async {
    final db = await database;

    var episode = await db.query('Episode',
        where: 'guId = ?', whereArgs: <dynamic>[(newEpisode.guId)]);
    Episode episode_ =
        episode.isNotEmpty ? Episode.fromJson(episode.first) : null;

    if (episode_ != null) {
      newEpisode.id = episode_.id;
      if (episode_.episodeDownloadPercentageProgress == 0) {
        db.delete('Episode',
            where: 'id = ?', whereArgs: <dynamic>[episode_.id]);
        _episodeNotifier.add(newEpisode);
      } else {
        newEpisode.episodeFavorited = false;
        await updateEpisode(newEpisode);
        _episodeNotifier.add(newEpisode);
      }
    }
    return 0;
  }

  Future<List<Episode>> findFavorites() async {
    final db = await database;
    var episodes = await db.query('Episode',
        where: 'episodeFavorited = ?', whereArgs: <dynamic>[1]);
    List<Episode> list = episodes.isNotEmpty
        ? episodes.map((map) => Episode.fromJson(map)).toList()
        : [];
    return list;
  }
}
