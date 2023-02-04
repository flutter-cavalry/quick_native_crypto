[![pub package](https://img.shields.io/pub/v/quick_native_crypto.svg)](https://pub.dev/packages/quick_native_crypto)

A Flutter plugin for native crypto APIs.

| iOS | Android | macOS |
| --- | ------- | ----- |
| ✅  | ✅      | ✅    |

## Usage

```dart
///
/// Encrypts [plaintext] using AES-GCM based on [key] and [nonce].
///
/// Valid key lengths are 128, 192, or 256 bits.
/// Returns a [SealedBox] containing a [ciphertext] and a [mac].
Future<SealedBox> aesEncrypt(
    {required Uint8List plaintext,
    required Uint8List key,
    required Uint8List nonce});

///
/// Decrypts [ciphertext] with AES-GCM based on [key], [nonce] and [mac].
///
/// Valid key lengths are 128, 192, or 256 bits.
/// Returns a [Uint8List] as decrypted data.
Future<Uint8List> aesDecrypt(
    {required Uint8List ciphertext,
    required Uint8List key,
    required Uint8List nonce,
    required Uint8List mac});
```

```dart
final plugin = QuickNativeCrypto();

var sealedBox = await plugin.aesEncrypt(...);
var plaintext = await plugin.aesDecrypt(...);
```
