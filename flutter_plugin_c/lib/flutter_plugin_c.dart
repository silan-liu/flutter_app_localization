
import 'dart:async';

import 'package:flutter/services.dart';

class FlutterPlugin_c {
  static const MethodChannel _channel = MethodChannel('flutter_plugin_c');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
