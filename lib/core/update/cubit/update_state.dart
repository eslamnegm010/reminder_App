import 'package:equatable/equatable.dart';

enum UpdateStatus {
  /// No check has been performed yet.
  initial,

  /// Currently checking for updates with Shorebird.
  checking,

  /// A new patch is available for download (user hasn't started download).
  available,

  /// The patch is actively being downloaded.
  downloading,

  /// Download finished — a restart is needed to apply the patch.
  ready,

  /// The app is fully up to date; no action required.
  upToDate,

  /// A patch was silently applied by the engine (detected on re-launch).
  /// Show a "What's New / Update Successful" dialog for transparency.
  applied,

  /// Something went wrong during check or download.
  error,
}

class UpdateState extends Equatable {
  final UpdateStatus status;
  final double downloadProgress;
  final String? errorMessage;
  final int? currentPatchNumber;

  const UpdateState({
    this.status = UpdateStatus.initial,
    this.downloadProgress = 0.0,
    this.errorMessage,
    this.currentPatchNumber,
  });

  UpdateState copyWith({
    UpdateStatus? status,
    double? downloadProgress,
    String? errorMessage,
    int? currentPatchNumber,
  }) {
    return UpdateState(
      status: status ?? this.status,
      downloadProgress: downloadProgress ?? this.downloadProgress,
      errorMessage: errorMessage,
      currentPatchNumber: currentPatchNumber ?? this.currentPatchNumber,
    );
  }

  @override
  List<Object?> get props => [
        status,
        downloadProgress,
        errorMessage,
        currentPatchNumber,
      ];
}
