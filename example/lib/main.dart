import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:quick_native_crypto/quick_native_crypto.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Uint8List _plaintext = utf8.encode(
      """The first version of Flutter was known as "Sky" and ran on the Android operating system. It was unveiled at the 2015 Dart developer summit[8] with the stated intent of being able to render consistently at 120 frames per second.[9] During the keynote of Google Developer Days in Shanghai in September 2018, Google announced Flutter Release Preview 2, the last major release before Flutter 1.0. On December 4th of that year, Flutter 1.0 was released at the Flutter Live event, denoting the first stable version of the framework. On December 11, 2019, Flutter 1.12 was released at the Flutter Interactive event.[10]

On May 6, 2020, the Dart software development kit (SDK) version 2.8 and Flutter 1.17.0 were released, adding support for the Metal API which improves performance on iOS devices by approximately 50%, as well as new Material widgets and network tracking development tools.
""") as Uint8List;
  final Uint8List _key =
      base64.decode('XFIiUfwpVnspx9zw2V2bwEscsIEVHJXwShq4BG2hO3s=');
  final Uint8List _nonce = base64.decode('p3QmkcK84NTR+PDn');
  final _plugin = QuickNativeCrypto();

  String _info = 'Running...';

  @override
  void initState() {
    super.initState();
    start();
  }

  Future<void> start() async {
    try {
      var res = await _plugin.aesEncrypt(
          plaintext: _plaintext, key: _key, nonce: _nonce);
      if (!mounted) return;
      var cipherBase64 = base64Encode(res.ciphertext);
      var decryptedText = utf8.decode(await _plugin.aesDecrypt(
          ciphertext: res.ciphertext, key: _key, nonce: _nonce, mac: res.mac));
      setState(() {
        _info =
            'Encrypted data: $cipherBase64\n\nDecrypted data: $decryptedText';
      });
    } catch (err) {
      setState(() {
        _info = 'Error: ${err.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(10),
            child: Text(_info),
          ),
        ),
      ),
    );
  }
}
