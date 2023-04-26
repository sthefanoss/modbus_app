import 'dart:typed_data';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

late Box<String> _box;

Future<void> initHive() async {
  await Hive.initFlutter();
  _box = await  Hive.openBox<String>('automacao2');
}

Box<String> get localStorage => _box;


Uint8List getCrc(Uint8List byteData) {
  int crc = 0xFFFF;

  for (final byte in byteData) {
    crc = crc ^ byte;
    for (int i = 0; i < 8; i++) {
      if (!((crc & 1) != 0)) {
        crc = crc >> 1;
      } else {
        crc = crc >> 1;
        crc = crc ^ 0xA001;
      }
    }
  }

  return Uint8List.fromList([crc & 0xFF, crc >> 8]);
}

Uint8List stringToBinary(String value) {
  if (value.length % 2 != 0) throw "invalid number of chars";

  final list = <int>[];

  for (int i = 0; i < value.length ~/ 2; i++) {
    list.add(((stringToHex[value[i << 1]]! << 4) +
        stringToHex[value[(i << 1) + 1]]!));
  }

  return Uint8List.fromList(list);
}

String binaryToString(Uint8List value) {
  final buffer = StringBuffer();
  for (final uInt8 in value) {
    final high = uInt8 >> 4;
    final low = uInt8 & 0xF;
    buffer.write("${hexToString[high]}${hexToString[low]}");
  }
  return buffer.toString();
}

const stringToHex = {
  "0": 0,
  "1": 1,
  "2": 2,
  "3": 3,
  "4": 4,
  "5": 5,
  "6": 6,
  "7": 7,
  "8": 8,
  "9": 9,
  "A": 10,
  "B": 11,
  "C": 12,
  "D": 13,
  "E": 14,
  "F": 15,
};

const hexToString = {
  0: "0",
  1: "1",
  2: "2",
  3: "3",
  4: "4",
  5: "5",
  6: "6",
  7: "7",
  8: "8",
  9: "9",
  10: "A",
  11: "B",
  12: "C",
  13: "D",
  14: "E",
  15: "F",
};
