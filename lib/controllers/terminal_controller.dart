import 'package:flutter/material.dart';

class TerminalController {
  final textController = TextEditingController();
  final commands = <String>[];
  bool fanEnabled = false;
  bool lampEnabled = false;

  late VoidCallback setState;
}
