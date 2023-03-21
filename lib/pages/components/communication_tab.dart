import 'package:flutter/material.dart';

import '../../controllers/communication_controller.dart';
import '../decorated_dropdownButton.dart';
import '../home_page.dart';

class CommunicationTab extends StatefulWidget {
  const CommunicationTab({required this.controller, super.key});

  final CommunicationController controller;

  @override
  State<CommunicationTab> createState() => _CommunicationTabState();
}

class _CommunicationTabState extends State<CommunicationTab> {
  @override
  Widget build(BuildContext context) {
    return ListView(padding: EdgeInsets.all(24), children: [
      DecoratedDropdownButton<String>(
        labelText: 'Porta',
        onChanged: widget.controller.onSelectCom,
        value: widget.controller.selectedCom,
        items: widget.controller.availablePorts,
        itemBuilder: (e) => DropdownMenuItem(
          value: e,
          child: Text(e),
        ),
      ),
      DecoratedDropdownButton<int>(
        labelText: 'Taxa',
        value: widget.controller.baudRate,
        onChanged: widget.controller.setBaudRate,
        items: CommunicationController.baudRatesOptions,
        itemBuilder: (e) => DropdownMenuItem(
          value: e,
          child: Text(e.toString()),
        ),
      ),
      DecoratedDropdownButton<int>(
        labelText: 'Paridade',
        value: widget.controller.parity,
        items: CommunicationController.parityBitsOptions.keys,
        onChanged: widget.controller.setParityBits,
        itemBuilder: (e) => DropdownMenuItem(
          value: e,
          child: Text(CommunicationController.parityBitsOptions[e]!),
        ),
      ),
      DecoratedDropdownButton<int>(
        labelText: 'StopBits',
        value: widget.controller.stopBits,
        items: CommunicationController.stopBitsOptions.keys,
        onChanged: widget.controller.setStopBits,
        itemBuilder: (e) => DropdownMenuItem(
          value: e,
          child: Text(CommunicationController.stopBitsOptions[e]!),
        ),
      ),
    ]);
  }
}
