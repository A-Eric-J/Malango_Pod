import 'dart:async';
import 'dart:developer';
import 'dart:isolate';
import 'dart:ui';
import 'package:malango_pod/const_values/assets.dart';
import 'package:malango_pod/enums/download_state.dart';
import 'package:malango_pod/models/download_progressing_model.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

/// A [DownloadManager] for handling downloading of episodes on your phone.
class DownloadManager {
  ReceivePort receivePort;
  StreamController downloadStreamController;

  DownloadManager() {
    downloadManagerInitialization();
  }

  Future downloadManagerInitialization() async {
    log('Initialising download manager');

    receivePort = ReceivePort();
    downloadStreamController = StreamController<DownloadProgressingModel>();

    /// initializing FlutterDownloader
    await FlutterDownloader.initialize();
    IsolateNameServer.removePortNameMapping(downloaderPortName);

    IsolateNameServer.registerPortWithName(
        receivePort.sendPort, downloaderPortName);

    var tasks = await FlutterDownloader.loadTasks();

    /// Updating the status of any tasks that may have been updated when the app was closed or in the background.
    if (tasks != null && tasks.isNotEmpty) {
      for (var task in tasks) {
        updatingDownloadState(
            id: task.taskId, progress: task.progress, status: task.status);

        /// Note that If we are not queued or running we can safely clean up this event
        if (task.status != DownloadTaskStatus.enqueued &&
            task.status != DownloadTaskStatus.running) {
          FlutterDownloader.remove(
              taskId: task.taskId, shouldDeleteContent: false);
        }
      }
    }

    receivePort.listen((dynamic data) {
      updatingDownloadState(
          id: data[0] as String,
          progress: data[2] as int,
          status: data[1] as DownloadTaskStatus);
    });

    FlutterDownloader.registerCallback(downloadCallback);
  }

  /// Note that @pragma('vm:entry-point')
  /// must be placed above the callback function to avoid tree
  /// shaking in release mode for Android.
  @pragma('vm:entry-point')
  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final send = IsolateNameServer.lookupPortByName(downloaderPortName);

    send.send([id, status, progress]);
  }

  var lastUpdatedDownloadTime = 0;

  void updatingDownloadState(
      {String id, int progress, DownloadTaskStatus status}) {
    var state = DownloadState.none;

    log('status.value ${status.value}');
    switch (status.value) {
      case 1:
        state = DownloadState.queued;
        break;
      case 2:
        state = DownloadState.downloading;
        break;
      case 3:
        state = DownloadState.downloaded;
        break;
      case 4:
        state = DownloadState.failed;
        break;
      case 5:
        state = DownloadState.canceled;
        break;
      case 6:
        state = DownloadState.paused;
        break;
    }

    /// In case of running, it is important to restrict the frequency of notifications
    /// to once per second to avoid a flood of events that can be caused by frequent small downloads.
    /// On the other hand, we should always ensure that notifications are delivered for any other status.
    if (status != DownloadTaskStatus.running ||
        progress == 0 ||
        progress == 100 ||
        DateTime.now().millisecondsSinceEpoch >
            lastUpdatedDownloadTime + 1000) {
      downloadStreamController.add(DownloadProgressingModel(
          id: id, progressPercentage: progress, downloadState: state));
      lastUpdatedDownloadTime = DateTime.now().millisecondsSinceEpoch;
    }
  }

  Stream<DownloadProgressingModel> get downloadProgress =>
      downloadStreamController.stream;

  void dispose() {
    IsolateNameServer.removePortNameMapping(downloaderPortName);
    downloadStreamController.close();
  }
}
