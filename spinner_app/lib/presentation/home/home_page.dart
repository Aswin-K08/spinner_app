import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:spinner_app/presentation/home/home_page_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomePageController());

    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        title: const Text("Spin and Win"),
        backgroundColor: Colors.pink,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 300,
              child: FortuneWheel(
                animateFirst: false,
                selected: controller.selectedIndex.stream,
                items: List.generate(
                  controller.prizes.length,
                  (index) => FortuneItem(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        textAlign: TextAlign.center,
                        softWrap: true,
                        controller.prizes[index],
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    style: FortuneItemStyle(
                      color: controller.colors[index],
                      borderColor: Colors.white,
                      borderWidth: 2,
                    ),
                  ),
                ),
                onAnimationStart: () {
                  controller.isSpinning.value = true;
                },
                onAnimationEnd: () {
                  controller.showResult(
                    controller.prizes[controller.selectedIndex.value],
                  );
                },
              ),
            ),
            const SizedBox(height: 40),
            Obx(
              () => Text(
                'Spins left: ${controller.spinsLeft.value}/3',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Obx(
              () => ElevatedButton(
                onPressed: !controller.isSpinning.value
                    ? controller.spinWheel
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 60,
                    vertical: 16,
                  ),
                ),
                child: Text(
                  controller.isSpinning.value ? "SPINNING..." : "SPIN",
                  style: const TextStyle(fontSize: 22),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: controller.resetSpins,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 12,
                ),
              ),
              child: const Text("RESET SPINS", style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
