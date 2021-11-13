import 'package:flutter/material.dart';
import 'package:flutter_plugin_a/generated/l10n.dart';

class PluginAWidget extends StatelessWidget {
  const PluginAWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      height: 200,
      width: double.infinity,
      child: Center(
        child: Text(
          S.of(context).text,
          style: const TextStyle(
              fontSize: 13,
              decoration: TextDecoration.none,
              color: Colors.white),
        ),
      ),
    );
  }
}
