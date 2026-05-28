import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'services/notification_service.dart';
import 'services/storage_service.dart';
import 'views/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await StorageService.init();

  await NotificationService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Internet Monitor',
      home: DashboardScreen(),
    );
  }
}
