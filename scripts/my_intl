import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as RealIntl;
import '../generated/l10n.dart';
import '../generated/intl/messages_all.dart';
import 'package:intl/src/intl_helpers.dart';

class Intl {
  // copied from the real intl package
  static String message(String messageStr,
      {String desc: '',
        Map<String, Object> examples: const {},
        String? locale,
        String? name,
        List<Object>? args,
        String? meaning,
        bool? skip}) =>
      _message(messageStr, locale, name, args, meaning) ?? '';

  // copied from the real intl package
  static String? _message(String messageStr, String? locale, String? name,
      List<Object>? args, String? meaning) {
    return myMessageLookup.lookupMessage(
        messageStr, locale, name, args, meaning);
  }

  // 因为 intl 中 messageLookup 是全局变量，只会初始化一次，所有插件共用。
  // 在调用 messageLookup.addLocale 时会判断 locale 是否已存在，在多插件场景下，只有第一个插件生效。
  // 所以每个模块定义自己的 myMessageLookup，避免冲突。
  // messageLookup 的生成在 message_all.dart，在里面自定义 getMessageLookup 方法生成新实例。
  static MessageLookup myMessageLookup =
  UninitializedLocaleData('initializeMessages(<locale>)', null);

  static Future<S> load(Locale locale) {
    final name = locale.countryCode?.isEmpty ?? true
        ? locale.languageCode
        : locale.toString();
    final localeName = RealIntl.Intl.canonicalizedLocale(name);

    return getMessageLookup(localeName).then((value) {
      if (value != null) {
        myMessageLookup = value;

        RealIntl.Intl.defaultLocale = localeName;
      }

      return S();
    });
  }
}


