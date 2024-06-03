package com.example.method_channel

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity(){
    private val CHANNEL = "flutter_native_channel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)

        channel.setMethodCallHandler { call, result ->
                if (call.method == "getMessageFromNative") {
                    println(call.arguments)
                    result.success("I am callback from Native")
                } else {
                    result.notImplemented()
                }
            }

        channel.invokeMethod("getMessageFromFlutter", "I am message from Native", object : MethodChannel.Result {
            override fun success(result: Any?) {
                println(result)
            }
            override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
                println("Not Implemented")
            }
            override fun notImplemented() {
                println("Not Implemented")
            }
        })
    }
}
