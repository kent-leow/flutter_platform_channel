package com.example.basic_message_channel

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.BasicMessageChannel
import io.flutter.plugin.common.StringCodec

class MainActivity: FlutterActivity(){
    private val CHANNEL = "flutter_native_channel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine){
        super.configureFlutterEngine(flutterEngine)

        val channel = BasicMessageChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL, StringCodec.INSTANCE)

        channel.setMessageHandler { message, reply ->
            println("Received message: $message")
            reply.reply("I am callback from android")

            channel.send("I am message from android") { reply ->
                println("Received callback: $reply")
            }
        }

    }
}
