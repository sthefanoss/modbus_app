import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:modbus_app/controllers/test_controller.dart';
import 'package:modbus_app/utils/utils.dart';

import 'pages/home_page.dart';

void main() async {
  await initHive();
  TestController.instance.init();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Semana Acadêmica da Eng. Elétrica IFSUL',
      navigatorKey: navigatorKey,
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: child,
        );
      },
      home: HomePage(),
    );
  }
}
