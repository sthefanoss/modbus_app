import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:modbus_app/pages/components/terminal_tab.dart';

import '../controllers/communication_controller.dart';
import '../controllers/terminal_controller.dart';
import 'components/communication_tab.dart';



class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _cController = CommunicationController();
  final _tController = TerminalController();

  @override
  void initState() {
    super.initState();
    _cController.setState = () => setState(() {});
    _tController.setState = () => setState(() {});
    initPorts();
  }

  void initPorts() {
    _cController.availablePorts.clear();
    setState(
      () => _cController.availablePorts.addAll(
        SerialPort.availablePorts..sort(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(text: 'Comunicação', icon: Icon(Icons.cable)),
              Tab(text: 'Terminal', icon: Icon(Icons.terminal))
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            CommunicationTab(controller: _cController),
            TerminalTab(
              controller: _tController,
              cController: _cController,
            ),
          ],
        ),
      ),
    );
  }
}
