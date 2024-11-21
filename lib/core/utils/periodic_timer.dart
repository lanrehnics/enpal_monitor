import 'dart:async';

class PeriodicTimer {
  Timer? _timer;
  Duration? duration;

  PeriodicTimer(this.duration);

  void startTimer(Function callback) {
    // Cancel any existing timer if running
    stopTimer();

    // Start a new periodic timer
    _timer = Timer.periodic(duration ?? const Duration(seconds: 30), (timer) {
      callback();
    });
  }

  void stopTimer() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
  }
}
