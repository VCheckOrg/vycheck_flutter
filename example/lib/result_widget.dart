import 'package:flutter/material.dart';
import 'dart:async';

class ResultWidget extends StatefulWidget {
  const ResultWidget({Key? key}) : super(key: key);

  @override
  State<ResultWidget> createState() => _ResultWidgetState();
}

class _ResultWidgetState extends State<ResultWidget> {
  String _status = "";
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _status = "Waiting for final verification status...";
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _status = "Verification in progress...";
        _timer?.cancel();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('VCheck Flutter demo'),
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  const SizedBox(width: 0, height: 150),
                  Text(_status),
                  const SizedBox(width: 0, height: 50),
                ],
              ),
            ),
          ),
        ));
  }

  Future<bool> _onWillPop() async {
    _timer?.cancel();
    _timer = null;
    return true;
  }
}
