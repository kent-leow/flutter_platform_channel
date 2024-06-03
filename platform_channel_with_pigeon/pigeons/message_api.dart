import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(PigeonOptions(
  dartPackageName: 'pigeon_message_api',
  dartOut: 'lib/pigeons/message_api.g.dart',
  dartOptions: DartOptions(),
  kotlinOut:
      'android/app/src/main/kotlin/com/example/platform_channel_with_pigeon/pigeons/MessageApi.g.kt',
  kotlinOptions: KotlinOptions(
      package: 'com.example.platform_channel_with_pigeon.pigeons'),
  // cppOptions: CppOptions(namespace: 'pigeon_example'),
  // cppHeaderOut: 'windows/runner/messages.g.h',
  // cppSourceOut: 'windows/runner/messages.g.cpp',
  // javaOut: 'android/app/src/main/java/io/flutter/plugins/Messages.java',
  // javaOptions: JavaOptions(),
  // swiftOut: 'ios/Runner/Messages.g.swift',
  // swiftOptions: SwiftOptions(),
  // objcHeaderOut: 'macos/Runner/messages.g.h',
  // objcSourceOut: 'macos/Runner/messages.g.m',
  // // Set this to a unique prefix for your plugin or application, per Objective-C naming conventions.
  // objcOptions: ObjcOptions(prefix: 'PGN'),
  // copyrightHeader: 'pigeons/copyright.txt',
))
@HostApi()
abstract class MessageApi {
  @async
  String getMessageFromNative(String message);
}

@FlutterApi()
abstract class ReverseMessageApi {
  @async
  String getMessageFromFlutter(String message);
}
