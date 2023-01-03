// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter/animation.dart';

class Debounce {
  final int millisecondes;
  Debounce({
    // 디폴트 값으로 500
    this.millisecondes = 500,
  });
  // 옵셔널로
  Timer? _timer;

  void run(VoidCallback action) {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: millisecondes), action);
  }
}
