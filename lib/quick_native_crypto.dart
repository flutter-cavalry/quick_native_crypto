import 'package:flutter/foundation.dart';

import 'quick_native_crypto_platform_interface.dart';

class QuickNativeCrypto {
  Future<SealedBox> aesEncrypt(
      {required Uint8List plaintext,
      required Uint8List key,
      required Uint8List nonce}) async {
    return QuickNativeCryptoPlatform.instance
        .aesEncrypt(plaintext: plaintext, key: key, nonce: nonce);
  }

  Future<Uint8List> aesDecrypt(
      {required Uint8List ciphertext,
      required Uint8List key,
      required Uint8List nonce,
      required Uint8List mac}) async {
    return QuickNativeCryptoPlatform.instance
        .aesDecrypt(ciphertext: ciphertext, key: key, nonce: nonce, mac: mac);
  }
}
