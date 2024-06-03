package com.example.event_channel

import android.os.Build
import android.os.Handler
import android.os.Looper
import androidx.annotation.RequiresApi
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import java.time.Instant

class MainActivity: FlutterActivity(){
    private val CHANNEL = "flutter_native_channel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setStreamHandler(
            object : EventChannel.StreamHandler {
                var mainHandler: Handler = Handler(Looper.getMainLooper())
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    mainHandler.post(object : Runnable {
                        @RequiresApi(Build.VERSION_CODES.O)
                        override fun run() {
                            events?.success(Instant.now().toString())
                            mainHandler.postDelayed(this, 1000)
                        }
                    })
                }
                override fun onCancel(arguments: Any?) {
                    mainHandler.removeCallbacksAndMessages(null)
                }
            })
    }
}
