import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HomePageController extends GetxController {
  final RxInt selectedIndex = 0.obs;
  final RxInt spinsLeft = 3.obs;
  final RxString nextResetTime = ''.obs;
  final RxBool isSpinning = false.obs;
  Timer? _resetTimer;
  late final GetStorage _storage;
  static const int _maxSpins = 3;

  final List<String> prizes = [
    '🎁 20% OFF',
    '😅 Better Luck Next Time',
    '🎉 Mystery Gift',
    '😅 Better Luck Next Time',
    '🚚 Free Delivery',
    '😅 Better Luck Next Time',
    '💸 Flat ₹100 OFF',
  ];

  final List<Color> colors = [
    Colors.red,
    Colors.blue,
    Colors.orange,
    Colors.blue,
    Colors.green,
    Colors.blue,
    Colors.purple,
  ];

  @override
  void onInit() {
    super.onInit();
    _storage = Get.find<GetStorage>();
    _checkSpinLimit();
    _scheduleReset();
  }

  void _scheduleReset() {
    final lastReset = DateTime.tryParse(_storage.read('lastReset') ?? '');
    if (lastReset == null) return;

    final nextReset = lastReset.add(const Duration(hours: 1));
    final now = DateTime.now();

    if (nextReset.isAfter(now)) {
      _resetTimer = Timer(nextReset.difference(now), () {
        _resetSpins();
        _scheduleReset();
      });
    }
  }

  void _resetSpins() {
    spinsLeft.value = _maxSpins;
    _storage.write('spinsLeft', _maxSpins);
    _storage.write('lastReset', DateTime.now().toIso8601String());
    nextResetTime.value = '';
  }

  @override
  void onClose() {
    _resetTimer?.cancel();
    super.onClose();
  }

  void _checkSpinLimit() {
    final now = DateTime.now();
    final lastReset = DateTime.tryParse(_storage.read('lastReset') ?? '');

    if (lastReset == null || now.difference(lastReset).inHours >= 1) {
      _resetSpins();
    } else {
      spinsLeft.value = _storage.read('spinsLeft') ?? _maxSpins;
      _updateTimer(lastReset);
    }
  }

  void _updateTimer(DateTime lastReset) {
    final now = DateTime.now();
    final nextReset = lastReset.add(const Duration(hours: 1));
    final remaining = nextReset.difference(now);
    nextResetTime.value =
        '${remaining.inMinutes}m ${remaining.inSeconds % 60}s';
  }

  void spinWheel() {
    if (isSpinning.value) return;

    _checkSpinLimit();

    if (spinsLeft.value <= 0) {
      Get.snackbar(
        'Limit Reached',
        'You can spin again in ${nextResetTime.value}',
      );
      return;
    }

    final newIndex = Random().nextInt(prizes.length);
    selectedIndex.value = newIndex == selectedIndex.value
        ? (newIndex + 1) % prizes.length
        : newIndex;

    spinsLeft.value--;
    _storage.write('spinsLeft', spinsLeft.value);
  }

  void resetSpins() {
    _resetSpins();
    _scheduleReset();
  }

  void showResult(String prize) {
    isSpinning.value = false;
    Get.dialog(
      AlertDialog(
        title: const Text(" You Got"),
        content: prize == '😅 Better Luck Next Time'
            ? Text('Oops! $prize')
            : Text("Prize: $prize"),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("OK")),
        ],
      ),
    );
  }
}
