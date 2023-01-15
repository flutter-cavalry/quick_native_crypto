import 'package:flutter/foundation.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'quick_native_crypto_method_channel.dart';

/// Result type returned from encryption functions.
class SealedBox {
  final Uint8List ciphertext;
  final Uint8List mac;

  SealedBox(this.ciphertext, this.mac);
}

abstract class QuickNativeCryptoPlatform extends PlatformInterface {
  /// Constructs a QuickNativeCryptoPlatform.
  QuickNativeCryptoPlatform() : super(token: _token);

  static final Object _token = Object();

  static QuickNativeCryptoPlatform _instance = MethodChannelQuickNativeCrypto();

  /// The default instance of [QuickNativeCryptoPlatform] to use.
  ///
  /// Defaults to [MethodChannelQuickNativeCrypto].
  static QuickNativeCryptoPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [QuickNativeCryptoPlatform] when
  /// they register themselves.
  static set instance(QuickNativeCryptoPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<SealedBox> aesEncrypt(
      {required Uint8List plaintext,
      required Uint8List key,
      required Uint8List nonce}) async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<Uint8List> aesDecrypt(
      {required Uint8List ciphertext,
      required Uint8List key,
      required Uint8List nonce,
      required Uint8List mac}) async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
