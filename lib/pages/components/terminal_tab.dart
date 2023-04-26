import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modbus_app/controllers/communication_controller.dart';

import '../../controllers/terminal_controller.dart';
import '../../utils/utils.dart';

class TerminalTab extends StatefulWidget {
  const TerminalTab({super.key});

  @override
  State<TerminalTab> createState() => _TerminalTabState();
}

class _TerminalTabState extends State<TerminalTab> {
  final communicationController = CommunicationController.instance;
  final terminalController = TerminalController.instance;
  final key = GlobalKey<FormState>();

  @override
  void initState() {
    // communicationController.open();
    super.initState();
  }

  @override
  void dispose() {
    // communicationController.close();
    super.dispose();
  }

  // void func(Timer timer) {
  //   if (!mounted) timer.cancel();
  //   final read =
  //       communicationController.serialPort?.read(duration.inMilliseconds);
  //   if (read?.isEmpty ?? true) return;
  //   final length = read!.length;
  //   final payload = read.sublist(0, length - 2);
  //   final calculatedCrc = (read[read.length - 1] << 8) + read[read.length - 2];
  //   final crc = getCrc(payload);
  //   terminalController.commands.insert(
  //     0,
  //     "==================================\n"
  //     "Date: ${DateTime.now().toIso8601String()}\n"
  //     "RawData: ${read.toString()}\n"
  //     "Data: ${payload.toString()}\n"
  //     "evaluated crc: ${crc}\n"
  //     "raw crc: ${calculatedCrc}\n"
  //     "==================================\n",
  //   );
  //   setState(() {});
  //   communicationController.serialPort
  //       ?.write(read, timeout: duration.inMilliseconds);
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: terminalController,
      builder: (context, _) => Column(children: [
        Expanded(
            child: ListView.builder(
          itemCount: terminalController.commands.length,
          reverse: true,
          itemBuilder: (_, index) => FooCard(
            data: terminalController.commands[index],
          ),
        )),
        AnimatedBuilder(
          animation: communicationController,
          builder: (context, _) => Form(
            key: key,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Stack(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: terminalController.textController,
                          textInputAction: TextInputAction.send,
                          onEditingComplete:
                              communicationController.isLoading ? null : send,
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
                          validator: (v) {
                            if (v?.isEmpty == true) return "Campo obrigatório";
                            final lint = lintVerifications(v!);
                            if (lint != null) return lint;
                            if (v.length % 2 != 0)
                              return "Quantidade inválida de símbolos";
                            return null;
                          },
                          decoration: InputDecoration(
                            label: Text('Requisição (HEX)'),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                      IconButton(
                          onPressed:
                              communicationController.isLoading ? null : send,
                          icon: const Icon(Icons.send))
                    ],
                  ),
                  if (communicationController.isLoading)
                    const Positioned.fill(
                        child: Center(child: CircularProgressIndicator())),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }

  void send() {
    if (!key.currentState!.validate()) {
      return;
    }
    CommunicationController.instance
        .sendMessage(
      terminalController.textController.text,
    )
        .then((value) {
      if (value == null) return;
      terminalController.addCommand(value);
    });
  }
}

String? lintVerifications(String v) {
  if (v.length < 12) return "Envie pelo menos 6 bytes";
  return null;
}

class FooCard extends StatelessWidget {
  const FooCard({required this.data, Key? key}) : super(key: key);

  final Foo data;

  @override
  Widget build(BuildContext context) {
    final hasResponse = data.response.isNotEmpty;
    return ListTile(
      title: Column(
        children: [
          Row(children: [
            SelectableText(data.formattedRequestData),
            SizedBox(width: 18),
            Text("CRC (Low High): ${data.requestCrc}"),
          ]),
          Row(children: [
            if (hasResponse) ...[
              SelectableText(data.formattedResponseData),
              SizedBox(width: 18),
              Text("CRC (Low High): ${data.responseCrc}"),
            ] else
              Text("Sem resposta"),
          ]),
        ],
      ),
    );
  }
}
