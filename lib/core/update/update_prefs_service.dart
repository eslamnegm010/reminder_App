import 'package:shared_preferences/shared_preferences.dart';

/// Repository layer for managing Shorebird update lifecycle persistence.
///
/// Tracks two control flags in SharedPreferences:
/// - `update_pending_action`: User saw an update but clicked "Later" or closed
///   the app before restarting. Forces the dialog to reappear on next launch.
/// - `last_acknowledged_patch_version`: The patch number the user last
///   acknowledged. Used to detect silent updates applied by the engine.
class UpdatePrefsService {
  static const _keyPendingAction = 'update_pending_action';
  static const _keyLastAcknowledgedPatch = 'last_acknowledged_patch_version';

  final SharedPreferences _prefs;

  UpdatePrefsService(this._prefs);

  // ─── Pending Action Flag ───────────────────────────────────────────

  /// Returns `true` if the user has a pending update they haven't acknowledged.
  /// This is set when an update is detected/downloaded and cleared only when
  /// the user taps "Restart Now" or "Got it!".
  bool get hasPendingAction => _prefs.getBool(_keyPendingAction) ?? false;

  /// Sets or clears the pending action flag.
  Future<void> setPendingAction(bool value) async {
    await _prefs.setBool(_keyPendingAction, value);
  }

  // ─── Last Acknowledged Patch Version ───────────────────────────────

  /// Returns the patch version the user last acknowledged (or 0 if none).
  int get lastAcknowledgedPatch =>
      _prefs.getInt(_keyLastAcknowledgedPatch) ?? 0;

  /// Stores the patch version after the user successfully acknowledges it.
  /// This prevents the "Welcome to new version" dialog from re-appearing
  /// for the same patch on subsequent launches.
  Future<void> setLastAcknowledgedPatch(int patchNumber) async {
    await _prefs.setInt(_keyLastAcknowledgedPatch, patchNumber);
  }

  /// Clears all update-related preferences (useful for testing/reset).
  Future<void> clearAll() async {
    await _prefs.remove(_keyPendingAction);
    await _prefs.remove(_keyLastAcknowledgedPatch);
  }
}
