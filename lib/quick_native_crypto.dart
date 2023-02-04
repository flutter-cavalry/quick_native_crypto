import 'package:flutter/foundation.dart';

import 'quick_native_crypto_platform_interface.dart';

class QuickNativeCrypto {
  ///
  /// Encrypts [plaintext] using AES-GCM based on [key] and [nonce].
  ///
  /// Valid key lengths are 128, 192, or 256 bits.
  /// Returns a [SealedBox] containing a [ciphertext] and a [mac].
  Future<SealedBox> aesEncrypt(
      {required Uint8List plaintext,
      required Uint8List key,
      required Uint8List nonce}) async {
    return QuickNativeCryptoPlatform.instance
        .aesEncrypt(plaintext: plaintext, key: key, nonce: nonce);
  }

  ///
  /// Decrypts [ciphertext] with AES-GCM based on [key], [nonce] and [mac].
  ///
  /// Valid key lengths are 128, 192, or 256 bits.
  /// Returns a [Uint8List] as decrypted data.
  Future<Uint8List> aesDecrypt(
      {required Uint8List ciphertext,
      required Uint8List key,
      required Uint8List nonce,
      required Uint8List mac}) async {
    return QuickNativeCryptoPlatform.instance
        .aesDecrypt(ciphertext: ciphertext, key: key, nonce: nonce, mac: mac);
  }
}
