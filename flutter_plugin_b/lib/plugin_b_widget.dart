import 'package:flutter/material.dart';
import 'package:flutter_plugin_b/generated/l10n.dart';

class PluginBWidget extends StatelessWidget {
  const PluginBWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
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
