
import 'dart:async';

import 'package:flutter/services.dart';

class FlutterPlugin_b {
  static const MethodChannel _channel = MethodChannel('flutter_plugin_b');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
