import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'quick_native_crypto_platform_interface.dart';

/// An implementation of [QuickNativeCryptoPlatform] that uses method channels.
class MethodChannelQuickNativeCrypto extends QuickNativeCryptoPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('quick_native_crypto');

  @override
  Future<SealedBox> aesEncrypt(
      {required Uint8List plaintext,
      required Uint8List key,
      required Uint8List nonce}) async {
    final res = (await methodChannel.invokeMapMethod<String, dynamic>(
        'aesEncrypt', {'plaintext': plaintext, 'key': key, 'nonce': nonce}))!;
    return SealedBox(res['ciphertext'] as Uint8List, res['mac'] as Uint8List);
  }

  @override
  Future<Uint8List> aesDecrypt(
      {required Uint8List ciphertext,
      required Uint8List key,
      required Uint8List nonce,
      required Uint8List mac}) async {
    final res = (await methodChannel.invokeMapMethod<String, dynamic>(
        'aesDecrypt',
        {'ciphertext': ciphertext, 'key': key, 'nonce': nonce, 'mac': mac}))!;
    return res['plaintext'] as Uint8List;
  }
}
