import 'package:flutter/material.dart';

class TriggerAnimations extends ChangeNotifier {
  bool _trigger = false;
  bool _isAnimationFinish = false;
  bool _isTransition = false;

  bool get trigger => _trigger;
  bool get isAnimationFinish => _isAnimationFinish;
  bool get isTransition => _isTransition;

  set trigger(bool trigger) {
    _trigger = trigger;
    notifyListeners();
  }
  set isAnimationFinish(bool flag) {
    _isAnimationFinish = flag;
    notifyListeners();
  }
  set isTransition(bool flag) {
    _isTransition = flag;
    notifyListeners();
  }
}
