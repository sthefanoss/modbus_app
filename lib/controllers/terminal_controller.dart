import 'package:flutter/material.dart';

class TerminalController {
  final textController = TextEditingController();
  final commands = <String>[];
  late VoidCallback setState;
}
