enum DownloadState {
  none,
  queued,
  downloading,
  failed,
  canceled,
  paused,
  downloaded
}

DownloadState downloadState(int downloadStateIndex) {
  switch (downloadStateIndex) {
    case 0:
      return DownloadState.none;
      break;
    case 1:
      return DownloadState.queued;
      break;
    case 2:
      return DownloadState.downloading;
      break;
    case 3:
      return DownloadState.failed;
      break;
    case 4:
      return DownloadState.canceled;
      break;
    case 5:
      return DownloadState.paused;
      break;
    case 6:
      return DownloadState.downloaded;
      break;
  }

  return DownloadState.none;
}
