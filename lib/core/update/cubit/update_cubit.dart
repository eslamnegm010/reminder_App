import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart' as shorebird;
import 'package:reminder_app/core/update/update_prefs_service.dart';
import 'update_state.dart';

class UpdateCubit extends Cubit<UpdateState> {
  UpdateCubit({required UpdatePrefsService prefsService})
      : _prefs = prefsService,
        super(const UpdateState());

  final shorebird.ShorebirdUpdater _updater = shorebird.ShorebirdUpdater();
  final UpdatePrefsService _prefs;

  // ──────────────────────────────────────────────────────────────────
  // PUBLIC API
  // ──────────────────────────────────────────────────────────────────

  /// Master entry-point — called on every app launch from [AppProviders].
  ///
  /// Decision tree:
  /// ```
  /// 1. Read current patch number via Shorebird SDK.
  /// 2. Compare with last_acknowledged_patch in SharedPreferences.
  ///    → currentPatch > lastAcknowledged? SILENT UPDATE detected.
  /// 3. Check pending action flag (user clicked "Later" before).
  ///    → pending? Force the dialog again.
  /// 4. Fresh Shorebird query for new patches.
  /// ```
  Future<void> checkForUpdate() async {
    if (!_updater.isAvailable) {
      emit(state.copyWith(status: UpdateStatus.upToDate));
      return;
    }

    // ── Step 1: Read current running patch number ──
    // Uses ShorebirdUpdater().readCurrentPatch() → Patch?.number
    final currentPatch = await _safeReadCurrentPatch();
    final currentPatchNumber = currentPatch?.number ?? 0;

    emit(state.copyWith(currentPatchNumber: currentPatchNumber));

    // ── Step 2: Detect silently-applied patch ──
    // Shorebird downloads & applies patches in the background by default.
    // If the running patch is newer than what the user last acknowledged,
    // a silent update took place — show the "Welcome to new version" dialog.
    final lastAcknowledged = _prefs.lastAcknowledgedPatch;

    if (currentPatchNumber > 0 && currentPatchNumber > lastAcknowledged) {
      // Clear any stale pending flag since the update already applied.
      await _prefs.setPendingAction(false);
      emit(state.copyWith(status: UpdateStatus.applied));
      return;
    }

    // ── Step 3: Re-entry check — user clicked "Later" in a previous session ──
    if (_prefs.hasPendingAction) {
      emit(state.copyWith(status: UpdateStatus.checking));

      try {
        final status = await _updater.checkForUpdate(
          track: shorebird.UpdateTrack.stable,
        );

        switch (status) {
          case shorebird.UpdateStatus.restartRequired:
            // Patch was downloaded previously — force the restart dialog.
            emit(state.copyWith(status: UpdateStatus.ready));
            return;
          case shorebird.UpdateStatus.outdated:
            // A new/different patch is available for download.
            emit(state.copyWith(status: UpdateStatus.available));
            return;
          case shorebird.UpdateStatus.upToDate:
          case shorebird.UpdateStatus.unavailable:
            // The pending flag was stale — clear it.
            await _prefs.setPendingAction(false);
            emit(state.copyWith(status: UpdateStatus.upToDate));
            return;
        }
      } catch (e) {
        if (kDebugMode) print('UpdateCubit.checkPending error: $e');
        // On network error, still force the dialog so user doesn't miss it.
        emit(state.copyWith(status: UpdateStatus.ready));
        return;
      }
    }

    // ── Step 4: Fresh check with Shorebird ──
    emit(state.copyWith(status: UpdateStatus.checking));

    try {
      final status = await _updater.checkForUpdate(
        track: shorebird.UpdateTrack.stable,
      );

      switch (status) {
        case shorebird.UpdateStatus.upToDate:
        case shorebird.UpdateStatus.unavailable:
          emit(state.copyWith(status: UpdateStatus.upToDate));
          break;
        case shorebird.UpdateStatus.restartRequired:
          await _prefs.setPendingAction(true);
          emit(state.copyWith(status: UpdateStatus.ready));
          break;
        case shorebird.UpdateStatus.outdated:
          await _prefs.setPendingAction(true);
          emit(state.copyWith(status: UpdateStatus.available));
          break;
      }
    } catch (e) {
      if (kDebugMode) print('UpdateCubit.checkForUpdate error: $e');
      emit(state.copyWith(
        status: UpdateStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  /// Starts the download — only triggered by the user clicking "Download Now".
  Future<void> startDownload() async {
    emit(state.copyWith(
      status: UpdateStatus.downloading,
      downloadProgress: 0.0,
    ));

    try {
      await _updater.update(track: shorebird.UpdateTrack.stable);

      // Keep pending flag active — user must click "Restart" to clear it.
      await _prefs.setPendingAction(true);

      emit(state.copyWith(
        status: UpdateStatus.ready,
        downloadProgress: 1.0,
      ));
    } on shorebird.UpdateException catch (e) {
      if (kDebugMode) print('UpdateCubit.startDownload error: ${e.message}');
      emit(state.copyWith(
        status: UpdateStatus.error,
        errorMessage: e.message,
      ));
    } catch (e) {
      if (kDebugMode) print('UpdateCubit.startDownload unexpected: $e');
      emit(state.copyWith(
        status: UpdateStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  /// Called when the user takes definitive action:
  ///   - Taps "Restart Now" (ready state)
  ///   - Taps "Got it!" (applied/silent update state)
  ///
  /// Clears the pending flag AND records the current patch as acknowledged
  /// so the "Welcome" dialog won't re-appear for this patch.
  Future<void> acknowledgeUpdate() async {
    await _prefs.setPendingAction(false);

    // Re-read the live patch number to store the most accurate value.
    final livePatch = await _safeReadCurrentPatch();
    final patchNumber = livePatch?.number ?? state.currentPatchNumber ?? 0;

    if (patchNumber > 0) {
      await _prefs.setLastAcknowledgedPatch(patchNumber);
    }
  }

  // ──────────────────────────────────────────────────────────────────
  // PRIVATE HELPERS
  // ──────────────────────────────────────────────────────────────────

  /// Safely reads the current patch from the Shorebird engine.
  /// Returns `null` if no patch is installed or on error.
  Future<shorebird.Patch?> _safeReadCurrentPatch() async {
    try {
      return await _updater.readCurrentPatch();
    } catch (e) {
      if (kDebugMode) print('UpdateCubit._safeReadCurrentPatch error: $e');
      return null;
    }
  }
}
