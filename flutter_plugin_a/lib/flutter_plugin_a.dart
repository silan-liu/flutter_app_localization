
import 'dart:async';

import 'package:flutter/services.dart';

class FlutterPlugin_a {
  static const MethodChannel _channel = MethodChannel('flutter_plugin_a');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
