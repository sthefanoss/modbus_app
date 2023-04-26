import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:modbus_app/utils/utils.dart';

class CommunicationController extends ChangeNotifier {
  CommunicationController._();
  static final instance = CommunicationController._();

  final availablePorts = <String>[];
  static const baudRatesOptions = <int>[9600, 19200, 38400, 57600, 115200];
  static const parityBitsOptions = {
    SerialPortParity.none: "Nenhum",
    SerialPortParity.odd: "Ímpar",
    SerialPortParity.even: "Par",
  };
  static const stopBitsOptions = {0: "Nenhum", 1: "1", 2: "2"};
  String? selectedCom;
  SerialPort? serialPort;

  int baudRate = baudRatesOptions.first;
  int stopBits = 1;
  int parity = SerialPortParity.none;

  void refreshPorts() {
    availablePorts
      ..clear()
      ..addAll(SerialPort.availablePorts..sort());
    notifyListeners();

    onSelectCom(availablePorts.last);
    setStopBits(1);
  }

  void onSelectCom(String? value) {
    selectedCom = value;
    notifyListeners();
  }

  void setBaudRate(int? value) {
    if (value == null) return;
    baudRate = value;
    notifyListeners();
  }

  void setParityBits(int? value) {
    if (value == null) return;
    parity = value;
    // SerialPortFlowControl.none
    notifyListeners();
  }

  void setStopBits(int? value) {
    if (value == null) return;
    stopBits = value;
    notifyListeners();
  }

  void open() {
    serialPort = SerialPort(selectedCom!)..openReadWrite();
    serialPort!.config = SerialPortConfig()
      ..baudRate = baudRate
      ..parity = parity
      ..stopBits = stopBits
      ..bits = 8
      ..rts = SerialPortRts.flowControl
      ..cts = SerialPortCts.flowControl
      ..dsr = SerialPortDsr.flowControl
      ..dtr = SerialPortDtr.flowControl
      ..setFlowControl(SerialPortFlowControl.xonXoff);
    // final config = SerialPortConfig.fromAddress(serialPort!.address);
    // config
    //   // ..bits = 8
    //   ..baudRate = baudRate
    //   ..parity = parity
    //   ..stopBits = stopBits;
    // print({
    //   serialPort!.name,
    //   config.address,
    //   config.baudRate,
    //   config.parity,
    //   config.stopBits,
    // });
    // serialPort!.config.baudRate = baudRate;
    // serialPort!.openReadWrite();
  }

  void close() {
    serialPort?.close();
    serialPort = null;
    print("fechou");
  }

  bool isLoading = false;

  Future<Foo?> sendMessage(String message) async {
    if (isLoading) return null;
    isLoading = true;
    notifyListeners();
    open();
    final messageAsBinary = stringToBinary(message);
    final messageCrc = getCrc(messageAsBinary);
    final request = Uint8List.fromList([...messageAsBinary, ...messageCrc]);

    serialPort?.flush();
    print(serialPort?.write(request, timeout: 50));
    final response = serialPort!.read(20, timeout: 550);
    final responseCrc = response.length > 2
        ? response.sublist(response.length - 2, response.length)
        : Uint8List(0);
    final formattedResponseData = response.length > 2
        ? binaryToString(response.sublist(0, response.length - 2))
        : "";
    close();
    await Future.delayed(Duration(milliseconds: 1000));
    isLoading = false;
    notifyListeners();
    return Foo(
      formattedRequestData: message,
      request: request,
      requestCrc: binaryToString(messageCrc),
      response: response,
      formattedResponseData: formattedResponseData,
      responseCrc: binaryToString(responseCrc),
    );
  }
}

class Foo {
  final Uint8List request;
  final Uint8List response;
  final String formattedResponseData;
  final String formattedRequestData;
  final String requestCrc;
  final String responseCrc;

  const Foo({
    required this.request,
    required this.formattedResponseData,
    required this.requestCrc,
    required this.response,
    required this.formattedRequestData,
    required this.responseCrc,
  });
}
