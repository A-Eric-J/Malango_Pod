import 'package:flutter/material.dart';
import 'package:malango_pod/enums/archives_type.dart';
import 'package:malango_pod/ui/shared/colors.dart';

/// Collection of IconButtons  that are using in MalangoPod

class HomeIcon extends StatelessWidget {
  final VoidCallback onTap;
  final bool isFill;
  final Color color;
  final double size;

  const HomeIcon(
      {Key key, this.onTap, this.isFill = true, this.color, this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return InkWell(
      splashColor: transparent,
      highlightColor: transparent,
      onTap: onTap,
      child: Icon(
        isFill ? Icons.home : Icons.home_outlined,
        size: size ?? width * 0.0533,
        color: color ?? brandMainColor,
      ),
    );
  }
}

class ArchivesIcon extends StatelessWidget {
  final VoidCallback onTap;
  final bool isFill;
  final Color color;
  final double size;

  const ArchivesIcon(
      {Key key, this.onTap, this.isFill = true, this.color, this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return InkWell(
      splashColor: transparent,
      highlightColor: transparent,
      onTap: onTap,
      child: Icon(
        isFill ? Icons.archive_rounded : Icons.archive_outlined,
        size: size ?? width * 0.0533,
        color: color ?? brandMainColor,
      ),
    );
  }
}

class ArchiveIconsList extends StatelessWidget {
  final ArchivesType archivesType;
  final Color color;
  final double size;

  const ArchiveIconsList({Key key, this.color, this.size, this.archivesType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Icon(
      iconData(),
      size: width * 0.07,
      color: color ?? brandMainColor,
    );
  }

  IconData iconData() {
    switch (archivesType) {
      case ArchivesType.subscribes:
        return Icons.bookmark_rounded;
      case ArchivesType.downloads:
        return Icons.download;
      case ArchivesType.favorites:
        return Icons.favorite;
      default:
        return Icons.bookmark_rounded;
    }
  }
}

class InfoIcon extends StatelessWidget {
  final VoidCallback onTap;
  final Color color;
  final double size;

  const InfoIcon({Key key, this.onTap, this.color, this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return InkWell(
      splashColor: transparent,
      highlightColor: transparent,
      onTap: onTap,
      child: Icon(
        Icons.info_outline,
        size: size ?? width * 0.0533,
        color: color ?? primaryDark,
      ),
    );
  }
}

class EpisodeIcon extends StatelessWidget {
  final VoidCallback onTap;
  final Color color;
  final double size;

  const EpisodeIcon({Key key, this.onTap, this.color, this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return InkWell(
      splashColor: transparent,
      highlightColor: transparent,
      onTap: onTap,
      child: Icon(
        Icons.music_note_sharp,
        size: size ?? width * 0.0533,
        color: color ?? primaryDark,
      ),
    );
  }
}

class ClearOrCloseIcon extends StatelessWidget {
  final VoidCallback onTap;
  final double size;
  final Color color;

  const ClearOrCloseIcon({Key key, this.onTap, this.size, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return InkWell(
      splashColor: transparent,
      highlightColor: transparent,
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            color: white,
            width: size != null ? size / 3 : width * 0.0213,
            height: size != null ? size / 3 : width * 0.0213,
          ),
          Icon(
            Icons.cancel_rounded,
            color: color ?? brandMainColor,
            size: size ?? width * 0.064,
          ),
        ],
      ),
    );
  }
}

class ArrowDownIcon extends StatelessWidget {
  final VoidCallback onTap;
  final Color color;
  final double size;

  const ArrowDownIcon({Key key, this.onTap, this.color, this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return InkWell(
      splashColor: transparent,
      highlightColor: transparent,
      onTap: onTap,
      child: Icon(
        Icons.keyboard_arrow_down_sharp,
        color: color ?? primaryDark,
        size: size ?? width * 0.0426,
      ),
    );
  }
}

class ArrowUpIcon extends StatelessWidget {
  final VoidCallback onTap;
  final Color color;
  final double size;

  const ArrowUpIcon({Key key, this.onTap, this.color, this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return InkWell(
      splashColor: transparent,
      highlightColor: transparent,
      onTap: onTap,
      child: Icon(
        Icons.keyboard_arrow_up_sharp,
        color: color ?? primaryDark,
        size: size ?? width * 0.0426,
      ),
    );
  }
}

class ArrowForwardIcon extends StatelessWidget {
  final VoidCallback onTap;
  final Color color;
  final double size;

  const ArrowForwardIcon({Key key, this.onTap, this.color, this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: onTap,
      child: Icon(
        Icons.arrow_forward_ios,
        color: color ?? primaryDark,
        size: size ?? width * 0.032,
      ),
    );
  }
}

class ArrowBackIcon extends StatelessWidget {
  final VoidCallback onTap;
  final Color color;
  final double size;

  const ArrowBackIcon({Key key, this.onTap, this.color, this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return InkWell(
      splashColor: transparent,
      highlightColor: transparent,
      onTap: onTap,
      child: Icon(
        Icons.arrow_back_ios_sharp,
        color: color ?? primaryDark,
        size: size ?? width * 0.064,
      ),
    );
  }
}

class ShareIcon extends StatelessWidget {
  final VoidCallback onTap;
  final double size;
  final Color color;

  const ShareIcon({Key key, this.onTap, this.color, this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return InkWell(
        splashColor: transparent,
        highlightColor: transparent,
        onTap: onTap,
        child: Icon(
          Icons.share,
          color: color ?? brandMainColor,
          size: size ?? width * 0.064,
        ));
  }
}

class SearchNotFoundIcon extends StatelessWidget {
  final VoidCallback onTap;
  final double size;
  final Color color;

  const SearchNotFoundIcon({Key key, this.onTap, this.color, this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return InkWell(
        splashColor: transparent,
        highlightColor: transparent,
        onTap: onTap,
        child: Icon(
          Icons.search_off,
          color: color ?? brandMainColor,
          size: size ?? width * 0.08,
        ));
  }
}

class DateIcon extends StatelessWidget {
  final VoidCallback onTap;
  final Color color;
  final double size;

  const DateIcon({Key key, this.onTap, this.color, this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return InkWell(
        splashColor: transparent,
        highlightColor: transparent,
        onTap: onTap,
        child: Icon(
          Icons.date_range,
          color: color ?? primaryTextColor,
          size: size ?? width * 0.056,
        ));
  }
}

class TimeIcon extends StatelessWidget {
  final VoidCallback onTap;
  final Color color;
  final double size;

  const TimeIcon({Key key, this.onTap, this.color, this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return InkWell(
        splashColor: transparent,
        highlightColor: transparent,
        onTap: onTap,
        child: Icon(
          Icons.access_time_sharp,
          color: color ?? primaryTextColor,
          size: size ?? width * 0.056,
        ));
  }
}

class FileIcon extends StatelessWidget {
  final VoidCallback onTap;
  final Color color;
  final double size;

  const FileIcon({Key key, this.onTap, this.color, this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return InkWell(
        splashColor: transparent,
        highlightColor: transparent,
        onTap: onTap,
        child: Icon(
          Icons.insert_drive_file_outlined,
          color: color ?? primaryTextColor,
          size: size ?? width * 0.056,
        ));
  }
}

class PlayIcon extends StatelessWidget {
  final VoidCallback onTap;
  final Color color;
  final double size;

  const PlayIcon({Key key, this.onTap, this.color, this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return InkWell(
        splashColor: transparent,
        highlightColor: transparent,
        onTap: onTap,
        child: Icon(
          Icons.play_arrow,
          color: color ?? primaryTextColor,
          size: size ?? width * 0.064,
        ));
  }
}

class PauseIcon extends StatelessWidget {
  final VoidCallback onTap;
  final Color color;
  final double size;

  const PauseIcon({Key key, this.onTap, this.color, this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return InkWell(
        splashColor: transparent,
        highlightColor: transparent,
        onTap: onTap,
        child: Icon(
          Icons.pause,
          color: color ?? primaryTextColor,
          size: size ?? width * 0.064,
        ));
  }
}

class RewindIcon extends StatelessWidget {
  final VoidCallback onTap;
  final Color color;
  final double size;

  const RewindIcon({Key key, this.onTap, this.color, this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return InkWell(
        splashColor: transparent,
        highlightColor: transparent,
        onTap: onTap,
        child: Icon(
          Icons.replay_10,
          size: size ?? width * 0.08,
          color: color ?? brandMainColor,
        ));
  }
}

class FastForwardIcon extends StatelessWidget {
  final VoidCallback onTap;
  final Color color;
  final double size;

  const FastForwardIcon({Key key, this.onTap, this.color, this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return InkWell(
        splashColor: transparent,
        highlightColor: transparent,
        onTap: onTap,
        child: Icon(
          Icons.forward_30,
          size: size ?? width * 0.08,
          color: color ?? brandMainColor,
        ));
  }
}

class FavoriteIcon extends StatelessWidget {
  final VoidCallback onTap;
  final Color color;
  final double size;
  final bool isFill;

  const FavoriteIcon(
      {Key key, this.onTap, this.color, this.size, this.isFill = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return InkWell(
        splashColor: transparent,
        highlightColor: transparent,
        onTap: onTap,
        child: Icon(
          isFill ? Icons.favorite : Icons.favorite_border_outlined,
          color: color ?? primaryTextColor,
          size: size ?? width * 0.056,
        ));
  }
}

class DeleteIcon extends StatelessWidget {
  final VoidCallback onTap;
  final double size;
  final Color color;
  final bool isFill;

  const DeleteIcon(
      {Key key, this.onTap, this.size, this.isFill = false, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return InkWell(
      splashColor: transparent,
      highlightColor: transparent,
      onTap: onTap,
      child: Icon(
        isFill ? Icons.delete : Icons.delete_outline,
        color: color ?? primaryErrorColor,
        size: size ?? width * 0.0533,
      ),
    );
  }
}

class DownloadIcon extends StatelessWidget {
  final VoidCallback onTap;
  final Color color;
  final double size;

  const DownloadIcon({Key key, this.onTap, this.color, this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return InkWell(
      splashColor: transparent,
      highlightColor: transparent,
      onTap: onTap,
      child: Icon(
        Icons.download_outlined,
        color: color ?? primaryDark,
        size: size ?? width * 0.0533,
      ),
    );
  }
}

class ReplayIcon extends StatelessWidget {
  final VoidCallback onTap;
  final bool isFill;
  final Color color;
  final double size;

  const ReplayIcon(
      {Key key, this.onTap, this.isFill = true, this.color, this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return InkWell(
      splashColor: transparent,
      highlightColor: transparent,
      onTap: onTap,
      child: Icon(
        isFill ? Icons.replay_circle_filled : Icons.replay,
        size: size ?? width * 0.0533,
        color: color ?? brandMainColor,
      ),
    );
  }
}

class SubscriptionIcon extends StatelessWidget {
  final VoidCallback onTap;
  final bool isFill;
  final Color color;
  final double size;

  const SubscriptionIcon(
      {Key key, this.onTap, this.isFill = true, this.color, this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return InkWell(
      splashColor: transparent,
      highlightColor: transparent,
      onTap: onTap,
      child: Icon(
        isFill ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
        size: size ?? width * 0.0533,
        color: color ?? brandMainColor,
      ),
    );
  }
}
