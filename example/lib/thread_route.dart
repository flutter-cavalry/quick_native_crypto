import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:quick_native_crypto/quick_native_crypto.dart';

class ThreadRoute extends StatefulWidget {
  const ThreadRoute({super.key});

  @override
  State<ThreadRoute> createState() => _ThreadRouteState();
}

class _ThreadRouteState extends State<ThreadRoute> {
  final QuickNativeCrypto _plugin = QuickNativeCrypto();
  final List<String> _results = [];
  final _random = Random();
  final Uint8List _key =
      base64.decode('XFIiUfwpVnspx9zw2V2bwEscsIEVHJXwShq4BG2hO3s=');
  final Uint8List _nonce = base64.decode('p3QmkcK84NTR+PDn');

  String _randomHexString(int length) {
    StringBuffer sb = StringBuffer();
    for (var i = 0; i < length; i++) {
      sb.write(_random.nextInt(16).toRadixString(16));
    }
    return sb.toString();
  }

  Future<void> _startTask(int idx) async {
    try {
      setState(() {
        _results[idx] = 'Running...';
      });
      await _plugin.aesEncrypt(
          plaintext: Uint8List.fromList(_randomHexString(500).codeUnits),
          key: _key,
          nonce: _nonce);
      setState(() {
        _results[idx] = 'Success';
      });
    } catch (err) {
      setState(() {
        _results[idx] = 'Error: ${err.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thread Route'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () async {
                  _results.add('');
                  await _startTask(_results.length - 1);
                },
                child: const Text('Add task'),
              ),
              const SizedBox(height: 10),
              Expanded(
                  child: ListView(
                children: _results
                    .asMap()
                    .entries
                    .map((e) => ListTile(
                          title: Text('Task ${e.key + 1}'),
                          subtitle: Text(e.value),
                        ))
                    .toList(),
              ))
            ],
          )),
    );
  }
}
