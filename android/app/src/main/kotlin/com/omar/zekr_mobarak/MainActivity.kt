package com.omar.zekr_mobarak

import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.media.MediaScannerConnection

class MainActivity : FlutterFragmentActivity() {
  // This channel name must match the one used in the Dart code.
  private val CHANNEL = "com.omar.zekr_mobarak/media_scanner"

  override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
      .setMethodCallHandler { call, result ->
        if (call.method == "scanFile") {
          val filePath = call.argument<String>("filePath")
          if (filePath != null) {
            // Trigger a media scan for the specified file.
            MediaScannerConnection.scanFile(
              this,
              arrayOf(filePath),
              null
            ) { path, uri ->
              // Optional: Log or handle callback if needed.
            }
            result.success(null)
          } else {
            result.error("INVALID_ARGUMENT", "File path is null", null)
          }
        } else {
          result.notImplemented()
        }
      }
  }
}
