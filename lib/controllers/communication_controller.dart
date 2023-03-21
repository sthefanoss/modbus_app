import 'dart:ui';

import 'package:flutter_libserialport/flutter_libserialport.dart';

class CommunicationController {
  final availablePorts = <String>[];
  static const baudRatesOptions = <int>[9600, 19200, 38400, 57600, 115200];
  static const parityBitsOptions = {0: "Nenhum", 1: "Ímpar", 2: "Par"};
  static const stopBitsOptions = {0: "Nenhum", 1: "1", 2: "2"};
  String? selectedCom;
  SerialPort? serialPort;
  SerialPortConfig? serialPortConfig;

  int baudRate = baudRatesOptions.first;
  int stopBits = 0;
  int parity = 0;

  void onSelectCom(String? value) {
    serialPort?.close();
    serialPortConfig?.dispose();
    serialPort = null;
    serialPortConfig = null;

    selectedCom = value;
    setState();

    if (value == null) return;
    serialPort = SerialPort(value)..openReadWrite();
    serialPortConfig = SerialPortConfig.fromAddress(serialPort!.address);
    serialPortConfig!.baudRate = baudRate;
    serialPortConfig!.parity = parity;
    serialPortConfig!.stopBits = stopBits;
  }

  void setBaudRate(int? value) {
    if (value == null) return;

    baudRate = value;
    serialPortConfig?.baudRate = value;
    setState();
  }

  void setParityBits(int? value) {
    if (value == null) return;

    parity = value;
    serialPortConfig?.parity = value;
    setState();
  }

  void setStopBits(int? value) {
    if (value == null) return;

    stopBits = value;
    serialPortConfig?.stopBits = value;
    setState();
  }

  late VoidCallback setState;
}
