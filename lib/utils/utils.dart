import 'dart:typed_data';

int getCrc(Uint8List byteData) {
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

  return crc;
}
