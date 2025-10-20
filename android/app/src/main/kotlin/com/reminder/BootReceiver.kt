package com.reminder.en

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Handler
import android.os.Looper
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.embedding.engine.loader.FlutterLoader
import io.flutter.FlutterInjector
import io.flutter.plugin.common.MethodChannel

class BootReceiver : BroadcastReceiver() {
    companion object {
        private const val CHANNEL = "reminder_boot"
    }

    override fun onReceive(context: Context, intent: Intent?) {
        if (intent?.action == Intent.ACTION_BOOT_COMPLETED) {
            try {
                val loader: FlutterLoader = FlutterInjector.instance().flutterLoader()
                loader.startInitialization(context)
                loader.ensureInitializationComplete(context, null)

                val flutterEngine = FlutterEngine(context.applicationContext)
                val entrypoint = DartExecutor.DartEntrypoint(
                    loader.findAppBundlePath(),
                    "main"
                )
                flutterEngine.dartExecutor.executeDartEntrypoint(entrypoint)

                Handler(Looper.getMainLooper()).postDelayed({
                    try {
                        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
                            .invokeMethod("rescheduleReminders", null)
                    } catch (e: Exception) {
                        e.printStackTrace()
                    } finally {
                        Handler(Looper.getMainLooper()).postDelayed({
                            try {
                                flutterEngine.destroy()
                            } catch (ignored: Exception) {}
                        }, 4000)
                    }
                }, 1000)
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }
    }
}
