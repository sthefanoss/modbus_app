import 'dart:async';

import 'package:flutter/material.dart';
import 'package:modbus_app/controllers/communication_controller.dart';

import '../../controllers/terminal_controller.dart';

class TerminalTab extends StatefulWidget {
  const TerminalTab({
    required this.controller,
    required this.cController,
    super.key,
  });

  final CommunicationController cController;

  final TerminalController controller;

  @override
  State<TerminalTab> createState() => _TerminalTabState();
}

class _TerminalTabState extends State<TerminalTab> {
  final duration = Duration(milliseconds: 10);

  @override
  void initState() {
    super.initState();
    Timer.periodic(duration, (timer) {
      if (!mounted) timer.cancel();
      final read = widget.cController.serialPort?.read(duration.inMilliseconds);
      if (read?.isEmpty ?? true) return;
      widget.controller.commands.add("IN: " + read.toString());
      setState(() {});
      widget.cController.serialPort
          ?.write(read!, timeout: duration.inMilliseconds);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
          child: ListView.builder(
        itemCount: widget.controller.commands.length,
        itemBuilder: (_, index) => Text(
          widget.controller.commands[index],
        ),
      )),
      Padding(
        padding: const EdgeInsets.all(24.0),
        child: TextField(
          controller: widget.controller.textController,
          textInputAction: TextInputAction.send,
          decoration: InputDecoration(
            label: Text('Enviar comando'),
            border: OutlineInputBorder(),
          ),
        ),
      ),
    ]);
  }
}
