import 'package:flutter/material.dart';
import 'package:modbus_app/controllers/theme_controller.dart';
import 'package:modbus_app/pages/components/terminal_tab.dart';

import '../controllers/communication_controller.dart';
import 'components/communication_tab.dart';
import 'components/test_tab.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    CommunicationController.instance.refreshPorts();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Supervisório Modbus'),
          actions: [
            IconButton(
                onPressed: ThemeController.instance.toggleTheme,
                icon: ThemeController.instance.isDarkTheme
                    ? Icon(Icons.dark_mode)
                    : Icon(Icons.light_mode))
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Comunicação', icon: Icon(Icons.cable)),
              Tab(text: 'Terminal', icon: Icon(Icons.terminal)),
              Tab(text: 'Testes', icon: Icon(Icons.check_circle_outline)),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            CommunicationTab(),
            TerminalTab(),
            TestTab(),
          ],
        ),
      ),
    );
  }
}
