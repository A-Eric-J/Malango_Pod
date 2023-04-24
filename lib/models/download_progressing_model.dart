import 'package:flutter/material.dart';
import 'package:malango_pod/enums/download_state.dart';

class DownloadProgressingModel {
  final String id;
  final int progressPercentage;
  final DownloadState downloadState;

  DownloadProgressingModel({
    @required this.id,
    @required this.progressPercentage,
    @required this.downloadState,
  });
}
