import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:malango_pod/const_values/assets.dart';
import 'package:malango_pod/models/background_player.dart';
import 'package:malango_pod/models/episode.dart';
import 'package:malango_pod/ui/shared/colors.dart';
import 'package:malango_pod/ui/shared/regex.dart';
import 'package:malango_pod/ui/shared/text.dart';
import 'package:malango_pod/ui/widgets/text/text_view.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

/// help_methods contains methods that are helping us (it's like a toolbox Lol;) ) in Ui and Services

void snackBar(String text, context,
    {GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey, Color color}) {
  if (scaffoldMessengerKey != null) {
    scaffoldMessengerKey.currentState.showSnackBar(SnackBar(
      duration: const Duration(milliseconds: 1500),
      content: TextView(
        text: text,
        color: color ?? white,
        size: 12,
      ),
    ));
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(milliseconds: 1500),
      content: TextView(
        text: text,
        color: color ?? white,
        size: 12,
      ),
    ));
  }
}

void addToClipBoard(String text, BuildContext context) {
  Clipboard.setData(ClipboardData(text: text)).then((_) {
    snackBar(addToClipBoardSnackBarMessageText, context);
  });
}

String timerFormat(Duration duration) {
  String twoDigits(int n) {
    if (n >= 10) return '$n';
    return '0$n';
  }

  var twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60).toInt());
  var twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60).toInt());

  return '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
}

String trim(String string) => string.replaceAll(whiteSpaceRegExp, '');

void onShare(BuildContext context, String shareText) async {
  final RenderBox box = context.findRenderObject() as RenderBox;
  await Share.share(shareText,
      sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
}

String printDuration(Duration duration) {
  String twoDigits(num n) => n.toString().padLeft(2, '0');
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  if (twoDigits(duration.inHours) == '00') {
    return '$twoDigitMinutes:$twoDigitSeconds';
  }
  return '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
}

String printDate(DateTime dateTime) {
  if (dateTime != null) {
    return ('${dateTime.year}-${dateTime.month}-${dateTime.day}');
  } else {
    return '';
  }
}

String removingHTMLPadding(String input) {
  return input
          ?.replaceAll('\n', '')
          ?.trim()
          ?.replaceAll(textDescriptionRegExp_2, '')
          ?.replaceAll(textDescriptionRegExp_1, '</p>') ??
      '';
}

/// List of timezone based on
/// https://en.wikipedia.org/wiki/List_of_time_zone_abbreviations,
/// check this link
/// to add or delete what ever you want
const timezones = {
  'ACDT': '+10:30',
  'ACST': '+09:30',
  'ACT': '-05:00',
  'ACWST': '+08:45',
  'ADT': '-03:00',
  'AEDT': '+11:00',
  'AEST': '+10:00',
  'AFT': '+04:30',
  'AKDT': '-08:00',
  'AKST': '-09:00',
  'AMST': '-03:00',
  'AMT': '+04:00',
  'ART': '-03:00',
  'AST': '-04:00',
  'AT': '-04:00',
  'AWST': '+08:00',
  'AZOST': '+00:00',
  'AZOT': '-01:00',
  'AZT': '+04:00',
  'BDT': '+08:00',
  'BIT': '-12:00',
  'BNT': '+08:00',
  'BOT': '-04:00',
  'BRST': '-02:00',
  'BRT': '-03:00',
  'BST': '+01:00',
  'BTT': '+06:00',
  'CAT': '+02:00',
  'CCT': '+06:30',
  'CDT': '-05:00',
  'CEST': '+02:00',
  'CET': '+01:00',
  'CHADT': '+13:45',
  'CHAST': '+12:45',
  'CHOST': '+09:00',
  'CHOT': '+08:00',
  'CHST': '+10:00',
  'CHUT': '+10:00',
  'CIST': '-08:00',
  'CIT': '+08:00',
  'CKT': '-10:00',
  'CLST': '-03:00',
  'CLT': '-04:00',
  'COST': '-04:00',
  'COT': '-05:00',
  'CST': '-06:00',
  'CT': '-06:00',
  'CVT': '-01:00',
  'CWST': '+08:45',
  'CXT': '+07:00',
  'DAVT': '+07:00',
  'DDUT': '+10:00',
  'EASST': '-05:00',
  'EAST': '-06:00',
  'EAT': '+03:00',
  'ECT': '-05:00',
  'EDT': '-04:00',
  'EEST': '+03:00',
  'EET': '+02:00',
  'EGST': '+00:00',
  'EGT': '-01:00',
  'EIT': '+09:00',
  'EST': '-05:00',
  'ET': '-05:00',
  'FET': '+03:00',
  'FJT': '+12:00',
  'FKST': '-03:00',
  'FKT': '-04:00',
  'FNT': '-02:00',
  'GALT': '-06:00',
  'GAMT': '-09:00',
  'GET': '+04:00',
  'GFT': '-03:00',
  'GILT': '+12:00',
  'GIT': '-09:00',
  'GMT': '+00:00',
  'GST': '-02:00',
  'GYT': '-04:00',
  'HADT': '-09:00',
  'HAST': '-10:00',
  'HKT': '+08:00',
  'HMT': '+05:00',
  'HOVST': '+08:00',
  'HOVT': '+07:00',
  'ICT': '+07:00',
  'IDT': '+03:00',
  'IOT': '+06:00',
  'IRDT': '+04:30',
  'IRKT': '+08:00',
  'IRST': '+03:30',
  'IST': '+01:00',
  'JST': '+09:00',
  'KGT': '+06:00',
  'KOST': '+11:00',
  'KRAT': '+07:00',
  'KST': '+09:00',
  'LHDT': '+11:00',
  'LHST': '+10:30',
  'LINT': '+14:00',
  'MAGT': '+11:00',
  'MART': '-09:30',
  'MAWT': '+05:00',
  'MDT': '-06:00',
  'MHT': '+12:00',
  'MIST': '+11:00',
  'MIT': '-09:30',
  'MMT': '+06:30',
  'MSK': '+03:00',
  'MST': '+08:00',
  'MT': '-07:00',
  'MUT': '+04:00',
  'MVT': '+05:00',
  'MYT': '+08:00',
  'NCT': '+11:00',
  'NDT': '-02:30',
  'NFT': '+11:00',
  'NPT': '+05:45',
  'NRT': '+12:00',
  'NST': '-03:30',
  'NT': '-03:30',
  'NUT': '-11:00',
  'NZDT': '+13:00',
  'NZST': '+12:00',
  'OMST': '+06:00',
  'ORAT': '+05:00',
  'PDT': '-07:00',
  'PET': '-05:00',
  'PETT': '+12:00',
  'PGT': '+10:00',
  'PHOT': '+13:00',
  'PHT': '+08:00',
  'PKT': '+05:00',
  'PMDT': '-02:00',
  'PMST': '-03:00',
  'PONT': '+11:00',
  'PST': '-08:00',
  'PT': '-08:00',
  'PWT': '+09:00',
  'PYST': '-03:00',
  'PYT': '-04:00',
  'RET': '+04:00',
  'ROTT': '-03:00',
  'SAKT': '+11:00',
  'SAMT': '+04:00',
  'SAST': '+02:00',
  'SBT': '+11:00',
  'SCT': '+04:00',
  'SGT': '+08:00',
  'SLST': '+05:30',
  'SRET': '+11:00',
  'SRT': '-03:00',
  'SST': '-11:00',
  'SYOT': '+03:00',
  'TAHT': '-10:00',
  'TFT': '+05:00',
  'THA': '+07:00',
  'TJT': '+05:00',
  'TKT': '+13:00',
  'TLT': '+09:00',
  'TMT': '+05:00',
  'TOT': '+13:00',
  'TRT': '+03:00',
  'TVT': '+12:00',
  'ULAST': '+09:00',
  'ULAT': '+08:00',
  'USZ1': '+02:00',
  'UTC': '+00:00',
  'UYST': '-02:00',
  'UYT': '-03:00',
  'UZT': '+05:00',
  'VET': '-04:00',
  'VLAT': '+10:00',
  'VOLT': '+04:00',
  'VOST': '+06:00',
  'VUT': '+11:00',
  'WAKT': '+12:00',
  'WAST': '+02:00',
  'WAT': '+01:00',
  'WEST': '+01:00',
  'WET': '+00:00',
  'WFT': '+12:00',
  'WGST': '-03:00',
  'WIB': '+07:00',
  'WIT': '+09:00',
  'WST': '+08:00',
  'YAKT': '+09:00',
  'YEKT': '+05:00',
};

const months = {
  'jan': '01',
  'feb': '02',
  'mar': '03',
  'apr': '04',
  'may': '05',
  'jun': '06',
  'jul': '07',
  'aug': '08',
  'sep': '09',
  'oct': '10',
  'nov': '11',
  'dec': '12',
};

const supportedTimePatterns = {
  /// 1) Sun, 09 Apr 2023 06:00:00 ACDT
  '([A-Za-z]{3}), ([0-9]{1,2}) ([A-Za-z]*) ([0-9]{4}) ([0-9][0-9]:[0-9][0-9]:[0-9][0-9]) ([A-Za-z]{3})':
      1,

  /// 2) Sun, 09 Apr 2023 08:00:00 +05:00
  '([A-Za-z]{3}), ([0-9]{1,2}) ([A-Za-z]*) ([0-9]{4}) ([0-9][0-9]:[0-9][0-9]:[0-9][0-9]) ([\+|\-][0-9][0-9]:[0-9][0-9])':
      2,

  /// 3) Sun, 09 Apr 2023 08:00:00 +0500
  '([A-Za-z]{3}), ([0-9]{1,2}) ([A-Za-z]*) ([0-9]{4}) ([0-9][0-9]:[0-9][0-9]:[0-9][0-9]) ([\+|\-][0-9][0-9][0-9][0-9])':
      2
};

/// see this
/// link : https://stackoverflow.com/questions/62289404/parse-rfc-822-date-and-make-timezones-work
/// to understand [parseRFC2822Date]
DateTime parseRFC2822Date(String date) {
  DateTime dateResult;
  supportedTimePatterns.forEach((key, value) {
    final exp = RegExp(key);

    if (exp.hasMatch(date)) {
      Match match = exp.firstMatch(date);

      /// converting to ISO
      var month = months[match.group(3).toLowerCase().substring(0, 3)];
      var match_1 = value == 1 ? timezones[match.group(6)] : match.group(6);
      var day = match.group(2).padLeft(2, '0');

      var iso = '${match.group(4)}-$month-${day}T${match.group(5)}$match_1';

      dateResult = DateTime.parse(iso);
    }
  });

  dateResult ??= DateTime.tryParse(date);

  return dateResult;
}

Future<String> getStorageDirectory() async {
  Directory directory;

  if (Platform.isIOS) {
    directory = await getApplicationDocumentsDirectory();
  } else {
    directory = await getApplicationSupportDirectory();
  }

  return join(directory.path, 'Malango');
}

/// removing chars from file and directory names that are invalid.
String pathRegExpChecker(String term) {
  var term_ = term?.replaceAll(RegExp(r'[^\w\s]+'), '');
  return term_?.trim();
}

String fileRegExpChecker(String term) {
  var term_ = term?.replaceAll(RegExp(r'[^\w\s\.]+'), '');
  return term_?.trim();
}

/// File & Directory
Future<String> getDirectory(
    {@required Episode episode, bool isFull = false}) async {
  if (isFull || Platform.isAndroid) {
    return Future.value(join(
        await getStorageDirectory(), pathRegExpChecker(episode.podcastName)));
  }

  return Future.value(pathRegExpChecker(episode.podcastName));
}

Future<String> getPath(Episode episode) async {
  if (Platform.isIOS) {
    return Future.value(join(await getStorageDirectory(),
        episode.episodeFilePath, episode.episodeFileName));
  }

  return Future.value(join(episode.episodeFilePath, episode.episodeFileName));
}

Future<void> makingDownloadDirectory(Episode episode) async {
  var path =
      join(await getStorageDirectory(), pathRegExpChecker(episode.podcastName));

  Directory(path).createSync(recursive: true);
}

String audioSourceDownloadedFile(String id) => "file://$id";

/// Permission handling for storage for subscribing, downloading, favoriting
Future<bool> storagePermission() async {
  final permissionStatus = await Permission.storage.request();
  log('permission: ${permissionStatus.toString()}');
  if (permissionStatus.isGranted) {
    log('if hasStoragePermission true');
    return Future.value(true);
  } else {
    if (permissionStatus.isPermanentlyDenied) {
      log('don\'t ask again in permission');
      openAppSettings();
      return Future.value(false);
    } else {
      log('if hasStoragePermission false');
      return Future.value(false);
    }
  }
}

/// this open the app setting for enable permission if it isPermanentlyDenied
Future<void> openAppSettings() async {
  await SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
  await openAppSettings();
}

/// BackgroundPlayer
Future<void> pauseBackgroundPlayerState(
    BackgroundPlayer backgroundPlayer) async {
  var backgroundPlayerEncodedJson = jsonEncode(backgroundPlayer.toJson());

  var directory = await getApplicationSupportDirectory();

  var directoryFile = File(join(directory.path, stateDotJson));

  var ioSink = directoryFile.openWrite();

  ioSink.write(backgroundPlayerEncodedJson);
  await ioSink.flush();
  await ioSink.close();
}

Future<void> clearBackgroundPlayerState() async {
  var directory = await getApplicationSupportDirectory();
  var directoryFile = File(join(directory.path, stateDotJson));

  if (directoryFile.existsSync()) {
    return directoryFile.delete();
  }
}

Future<BackgroundPlayer> getBackgroundPlayerState() async {
  var directory = await getApplicationSupportDirectory();

  var directoryFile = File(join(directory.path, stateDotJson));
  var newBackgroundPlayer = BackgroundPlayer.backgroundPlayerClear();

  if (directoryFile.existsSync()) {
    var result = directoryFile.readAsStringSync();

    if (result != null && result.isNotEmpty) {
      var data = jsonDecode(result) as Map<String, dynamic>;

      newBackgroundPlayer = BackgroundPlayer.fromJson(data);
    }
  }

  return Future.value(newBackgroundPlayer);
}
