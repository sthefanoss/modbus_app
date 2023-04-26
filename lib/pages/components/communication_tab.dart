import 'package:flutter/material.dart';

import '../../controllers/communication_controller.dart';
import '../decorated_dropdownButton.dart';

class CommunicationTab extends StatefulWidget {
  const CommunicationTab({super.key});

  @override
  State<CommunicationTab> createState() => _CommunicationTabState();
}

class _CommunicationTabState extends State<CommunicationTab> {
  final communicationController = CommunicationController.instance;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: communicationController,
      builder: (context, _) =>
          ListView(padding: const EdgeInsets.all(24), children: [
        DecoratedDropdownButton<String>(
          labelText: 'Porta',
          onChanged: communicationController.onSelectCom,
          value: communicationController.selectedCom,
          items: communicationController.availablePorts,
          itemBuilder: (e) => DropdownMenuItem(
            value: e,
            child: Text(e),
          ),
        ),
        DecoratedDropdownButton<int>(
          labelText: 'Taxa',
          value: communicationController.baudRate,
          onChanged: communicationController.setBaudRate,
          items: CommunicationController.baudRatesOptions,
          itemBuilder: (e) => DropdownMenuItem(
            value: e,
            child: Text(e.toString()),
          ),
        ),
        DecoratedDropdownButton<int>(
          labelText: 'Paridade',
          value: communicationController.parity,
          items: CommunicationController.parityBitsOptions.keys,
          onChanged: communicationController.setParityBits,
          itemBuilder: (e) => DropdownMenuItem(
            value: e,
            child: Text(CommunicationController.parityBitsOptions[e]!),
          ),
        ),
        DecoratedDropdownButton<int>(
          labelText: 'StopBits',
          value: communicationController.stopBits,
          items: CommunicationController.stopBitsOptions.keys,
          onChanged: communicationController.setStopBits,
          itemBuilder: (e) => DropdownMenuItem(
            value: e,
            child: Text(CommunicationController.stopBitsOptions[e]!),
          ),
        ),
      ]),
    );
  }
}
