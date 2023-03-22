import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modbus_app/controllers/communication_controller.dart';

import '../../controllers/terminal_controller.dart';
import '../../utils/utils.dart';

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
  final duration = const Duration(milliseconds: 100);
  final key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    Timer.periodic(duration, func);
  }

  void func(Timer timer) {
    if (!mounted) timer.cancel();
    final read = widget.cController.serialPort?.read(duration.inMilliseconds);
    if (read?.isEmpty ?? true) return;
    final length = read!.length;
    final payload = read.sublist(0, length - 2);
    final calculatedCrc = (read[read.length - 1] << 8) + read[read.length - 2];
    final crc = getCrc(payload);
    widget.controller.commands.insert(
      0,
      "==================================\n"
      "Date: ${DateTime.now().toIso8601String()}\n"
      "RawData: ${read.toString()}\n"
      "Data: ${payload.toString()}\n"
      "evaluated crc: ${crc}\n"
      "raw crc: ${calculatedCrc}\n"
      "==================================\n",
    );
    setState(() {});
    widget.cController.serialPort
        ?.write(read, timeout: duration.inMilliseconds);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
          child: ListView.builder(
        itemCount: widget.controller.commands.length,
        reverse: true,
        itemBuilder: (_, index) => Text(
          widget.controller.commands[index],
        ),
      )),
      Row(
        children: [
          Switch(
              value: widget.controller.fanEnabled,
              onChanged: (v) {
                if (v) {
                  widget.controller.textController.text = "01050009FF00";
                } else {
                  widget.controller.textController.text = "010500090000";
                }
                setState(() {
                  widget.controller.fanEnabled = v;
                });
                send();
              }),
          Text("Fan"),
          Switch(
              value: widget.controller.lampEnabled,
              onChanged: (v) {
                if (v) {
                  widget.controller.textController.text = "01050008FF00";
                } else {
                  widget.controller.textController.text = "010500080000";
                }
                setState(() {
                  widget.controller.lampEnabled = v;
                });
                send();
              }),
          Text("Lamp"),
        ],
      ),
      Form(
        key: key,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: TextFormField(
            controller: widget.controller.textController,
            textInputAction: TextInputAction.send,
            onEditingComplete: send,
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                RegExp(r'\d|[a-fA-F]'),
              ),
              TextInputFormatter.withFunction(
                (oldValue, newValue) => TextEditingValue(
                  text: newValue.text.toUpperCase(),
                  selection: newValue.selection,
                  composing: newValue.composing,
                ),
              ),
            ],
            validator: (v) {},
            decoration: InputDecoration(
              label: Text('Enviar comando (HEX)'),
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ),
    ]);
  }

  void send() {
    print(" fdfdf");
  }
}
