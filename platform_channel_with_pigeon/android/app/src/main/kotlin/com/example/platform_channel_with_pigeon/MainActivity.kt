package com.example.platform_channel_with_pigeon

import com.example.platform_channel_with_pigeon.pigeons.MessageApi
import com.example.platform_channel_with_pigeon.pigeons.ReverseMessageApi
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity: FlutterActivity(){
    class MessageApiImpl : MessageApi {

        override fun getMessageFromNative(message: String, callback:  (Result<String>) -> Unit) {
            callback(Result.success("I am callback from Native"))
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MessageApi.setUp(flutterEngine.dartExecutor.binaryMessenger, MessageApiImpl())

        ReverseMessageApi(flutterEngine.dartExecutor.binaryMessenger).getMessageFromFlutter(
            "I am message from Native",
            callback = { result ->
                println("$result")
            }
        )
    }
}
