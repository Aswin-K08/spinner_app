import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:spinner_app/presentation/home/home_page.dart';

void main() async {
  await GetStorage.init();
  Get.put(GetStorage());
  runApp(GetMaterialApp(debugShowCheckedModeBanner: false, home: HomePage()));
}
