package com.reminder.en  

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.TimeZone
import android.util.Log

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.reminder/timezone"
    private val TAG = "MainActivity"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getTimeZone") {
                try {
                    val tzId = TimeZone.getDefault().id ?: "UTC"
                    Log.d(TAG, "getTimeZone -> $tzId")
                    result.success(tzId)
                } catch (e: Exception) {
                    Log.w(TAG, "Failed to get timezone", e)
                    result.error("TZ_ERROR", "Failed to get timezone: ${e.message}", "UTC")
                }
            } else {
                result.notImplemented()
            }
        }
    }
}
