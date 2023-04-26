import 'package:flutter/material.dart';

import 'communication_controller.dart';

class TerminalController extends ChangeNotifier {
  TerminalController._() {
    textController.text = "01010064000A";
  }
  static final instance = TerminalController._();

  final textController = TextEditingController();

  final commands = <Foo>[];
  bool isLoading = false;

  void addCommand(Foo entry) {
    commands.insert(0, entry);
    notifyListeners();
  }
}
