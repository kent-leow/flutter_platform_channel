package com.example.battery_level

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel

class MainActivity: FlutterActivity(){
    private val channel = "flutter_native_channel"
    private var batteryLevelSink: EventChannel.EventSink? = null

    private val batteryStatusReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {
            sendBatteryStatus(getBatteryLevel(context))
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine){
        super.configureFlutterEngine(flutterEngine)
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, channel).setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    batteryLevelSink = events
                    registerBatteryReceiver()
                }

                override fun onCancel(arguments: Any?) {
                    batteryLevelSink = null
                    unregisterBatteryReceiver()
                }
            }
        )
    }

    private fun getBatteryLevel(context: Context?): Int {
        val batteryLevel: Int
        val batteryManager = context?.getSystemService(Context.BATTERY_SERVICE) as BatteryManager
        batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
        return batteryLevel
    }

    private fun registerBatteryReceiver() {
        val intentFilter = IntentFilter(Intent.ACTION_BATTERY_CHANGED)
        registerReceiver(batteryStatusReceiver, intentFilter)
    }

    private fun unregisterBatteryReceiver() {
        unregisterReceiver(batteryStatusReceiver)
    }

    private fun sendBatteryStatus(batteryPct: Int) {
        runOnUiThread {
            batteryLevelSink?.success(batteryPct)
        }
    }
}
