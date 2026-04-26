import 'package:flutter/foundation.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';

class ShorebirdUpdateService {
  static final ShorebirdUpdater _updater = ShorebirdUpdater();

  /// Checks if Shorebird is available (app was built with shorebird release).
  static bool get isAvailable => _updater.isAvailable;

  /// Gets the currently installed patch version, if any.
  static Future<Patch?> getCurrentPatch() async {
    try {
      return await _updater.readCurrentPatch();
    } catch (e) {
      if (kDebugMode) {
        print("Shorebird error reading current patch: $e");
      }
      return null;
    }
  }

  /// Checks if a new patch is available or ready to install on the given track.
  /// Defaults to the stable track.
  /// Returns [UpdateStatus] which can be:
  /// - upToDate: No new patches.
  /// - outdated: A new patch is available for download.
  /// - restartRequired: A new patch has been downloaded and requires an app restart.
  /// - unavailable: Shorebird is not available.
  static Future<UpdateStatus> checkUpdateStatus({
    UpdateTrack track = UpdateTrack.stable,
  }) async {
    try {
      return await _updater.checkForUpdate(track: track);
    } catch (e) {
      if (kDebugMode) {
        print("Shorebird error checking for update: $e");
      }
      return UpdateStatus.unavailable;
    }
  }

  /// Downloads the latest update for the given track.
  /// This should be called if checkUpdateStatus returns UpdateStatus.outdated.
  static Future<void> downloadUpdate({UpdateTrack track = UpdateTrack.stable}) async {
    try {
      await _updater.update(track: track);
    } on UpdateException catch (e) {
      if (kDebugMode) {
        print("Shorebird error downloading patch: ${e.message}");
      }
      rethrow; // Allows the UI to catch and display the error
    } catch (e) {
      if (kDebugMode) {
        print("Shorebird unexpected error downloading patch: $e");
      }
    }
  }
}
