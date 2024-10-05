import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:quick_native_crypto/quick_native_crypto.dart';
import 'package:quick_native_crypto_example/thread_route.dart';

const cipherCheck =
    "g9UCZsGagyDo/vdUDCJ1tmGP+fFCn4BT2ZRo5dO+c2QBSa5LWXi8omuRoHJo8O/d12G/zb9/susRd8MoA20diDity7nygX3RM61gzaufmNx4skqFODaxZx8NxZJ6iu//GeKJW+I4bqUHcL1kqzzynh9jRWjswrG+3QTadVzI5h9ednqMOimrD9F6YzpkXIqNTq6LRtTZreT+3VPlfkdWpsvmKadIEkcFHGqQN9VQSYAwR6FdS6l6IVZ3IIbUiDlq4eWgoRGHGhVzDpDIVnBlRKU9nLLHlSlZGk4uZ79DrPOYHNKZ+j89vjJxFw/avOolgfnnSFegz6eLstxpeoR/Xt883pKfZ5Ws+c2X9GUl4Z4gEJzeetsmI3NKq3IscpuxhG2FyppPpN9ATd6Qj69lXbAv9tTBdw0OuFzhumBuNZNmjaLAofbn0/vC5ZT413Myli3yTFvT+dCUhZbF7pFv+krUUP3we3w7C6alt65pRNKw5rb/F2HXjt5w0xflWVLZ276z3MpIJsldfONigokxpORcjQ4uyRG0OIquINp+kL1l7lJnF5f7XPp5zIT4SyKnogx7q7+1fivIV+a/zEfI3KNKXly4OQdCfnkwPuOtS4DD9LrC20CCn3907M63nEP+T8GPhDfy5/bDpFkU/NhOFxt9ffQvc3PvrEtokN8lmFsPJMHNqnxDUnpvYlD4meUdtZvk0L68dL6c2ePk6pE64X3H6JIUB/5LfC1cJefFHGyGkZqbc42bhN0Itjyn9peHnAZ0x6RHved88iNfHxQ4BDDiVl42sm6MNZ19/X1Ewwl9rK7HuKXkFhleF4Xhs33OqbT8fdvp4A+vaNtjY0oR4QtcG56A6yUCrPOSVW5ZaB6nG/DFfBq3zvAgAPk8Z/FPS2KsEihGwX9ukfCXHdcyrlbhiHUsnixZgDSTMBcsSw3mkM0VvBF0fA4DvIK4c+yCta2F2nr5lXIfUIYtbY+EiCXHEzMTJ+B/m7utcl/cKCFyRPEQlXiuUPoahIDUkkl82CXwXk4/PTG9RnBiwUpA32EdNyUKsCKDA9tzaiyop6WDgyjiLPJ/Qc79IwPa7hnYtDqCWa/rw5nUNjlv2U6wwxZTRVqA9YZ6xfjICM8/KL+DCLRS17PrvH2jaUph6NpMFDksG7iMygibIjy4OVMCHL5560Hz";

void main() {
  runApp(const MaterialApp(
    home: MyApp(),
  ));
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
""");
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
      if (cipherBase64 != cipherCheck) {
        throw 'Cipher value check failed';
      }
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(10),
          child: Column(
            children: [
              Text(_info),
              const SizedBox(
                height: 10,
              ),
              OutlinedButton(
                  onPressed: () async {
                    await Navigator.push<void>(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ThreadRoute()));
                  },
                  child: const Text('Test background thread'))
            ],
          ),
        ),
      ),
    );
  }
}
