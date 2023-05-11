import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:modbus_app/controllers/communication_controller.dart';
import 'package:modbus_app/controllers/terminal_controller.dart';
import 'package:modbus_app/utils/utils.dart';

class TestController extends ChangeNotifier {
  TestController._();

  void init() {
    try {
      final storage = localStorage.get('tests');
      final tests = jsonDecode(storage!) as List;
      for (final test in tests) {
        this.tests.add(Test.fromJson((test as Map).cast<String, String>()));
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static final instance = TestController._();

  final tests = <Test>[];

  Future<void> addTest(Test test) async {
    tests.add(test);
    await localStorage.put(
      'tests',
      jsonEncode(tests.map((e) => e.toJson()).toList()),
    );
    notifyListeners();
  }

  Future<void> editTest(int index, Test test) async {
    tests[index] = test;
    await localStorage.put(
      'tests',
      jsonEncode(tests.map((e) => e.toJson()).toList()),
    );
    notifyListeners();
  }

  Future<void> removeTest(Test test) async {
    tests.remove(test);
    await localStorage.put(
      'tests',
      jsonEncode(tests.map((e) => e.toJson()).toList()),
    );
    notifyListeners();
  }

  void resetTests() {
    for (final test in tests) {
      test.response = null;
    }
    notifyListeners();
  }

  Future<void> run(Test test) async {
    await CommunicationController.instance
        .sendMessage(test.request)
        .then((value) {
      test.response = value?.formattedResponseData ?? "";
      notifyListeners();
    });
  }

  void reorder(int index, int newPosition) {
    final test = tests[newPosition];
    tests[newPosition] = tests[index];
    tests[index] = test;
    notifyListeners();
  }
}

class Test {
  String name;
  String request;
  String expect;
  String? response;
  Duration delay;

  Test({
    required this.name,
    required this.request,
    required this.expect,
    this.delay = Duration.zero,
    this.response,
  });

  Test.fromJson(Map<String, String> json)
      : name = json['name'] ?? '',
        request = json['command']!,
        expect = json['expect']!,
        delay = Duration(
          microseconds: (int.tryParse(json['delay'] ?? '') ?? 0),
        );

  Map<String, String> toJson() => {
        'name': name,
        'command': request,
        'expect': expect,
        'delay': delay.inMicroseconds.toString(),
      };

  @override
  bool operator ==(other) {
    if (other is! Test) return false;
    return name == other.name &&
        request == other.request &&
        expect == other.expect &&
        delay == other.delay;
  }

  @override
  int get hashCode => Object.hashAll([
        name,
        request,
        expect,
        delay.inMicroseconds,
      ]);
}
