import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:modbus_app/controllers/test_controller.dart';
import 'package:modbus_app/controllers/theme_controller.dart';
import 'package:modbus_app/utils/utils.dart';

import 'pages/home_page.dart';

void main() async {
  await initHive();
  ThemeController.instance.init();
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
    return AnimatedBuilder(
      animation: ThemeController.instance,
      builder: (_, __) => MaterialApp(
        title: 'Semana Acadêmica da Eng. Elétrica IFSUL',
        navigatorKey: navigatorKey,
        theme: ThemeController.instance.isDarkTheme
            ? ThemeData.dark(useMaterial3: true)
            : ThemeData.light(useMaterial3: true),
        builder: (context, child) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: child,
          );
        },
        home: HomePage(),
      ),
    );
  }
}
