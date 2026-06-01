import 'dart:io';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path/path.dart' as path;

import '../models/gateway_model.dart';
import '../models/gateway_report.dart';
import '../models/log_model.dart';

class StorageService {
  static const String gatewayBox = "gateways";
  static const String logBox = "logs";

  static Future init() async {
    String hivePath;

    // For Windows desktop, use project directory
    if (Platform.isWindows) {
      // Save in the project folder (E:\flutter_app\internet_monitor\hive_data)
      String currentDir = Directory.current.path;
      hivePath = path.join(currentDir, 'hive_data');

      final hiveDir = Directory(hivePath);
      if (!await hiveDir.exists()) {
        await hiveDir.create(recursive: true);
      }

      Hive.init(hivePath);
      print('Hive initialized at: $hivePath');
    } else {
      // For mobile platforms
      await Hive.initFlutter();
    }

    await Hive.openBox(gatewayBox);
    await Hive.openBox(logBox);
    print('Boxes opened successfully');
  }

  static List<GatewayReport> generateReports() {
    final logs = loadLogs();

    Map<String, GatewayReport> reports = {};

    for (var log in logs) {
      reports.putIfAbsent(
        log.gatewayIp,
        () => GatewayReport(
          gatewayName: log.gatewayName,
          gatewayIp: log.gatewayIp,
          downCount: 0,
          totalDowntime: 0,
        ),
      );

      if (log.status == "DOWN") {
        reports[log.gatewayIp]!.downCount++;
      }

      if (log.status == "UP") {
        reports[log.gatewayIp]!.totalDowntime += log.durationMinutes;
      }
    }

    return reports.values.toList();
  }

  // Rest of your methods remain exactly the same...
  static Future clearLogs() async {
    final box = Hive.box(logBox);
    await box.put("logs", []);
  }

  static Future saveGateways(List<GatewayModel> gateways) async {
    final box = Hive.box(gatewayBox);

    List<Map<String, dynamic>> data = gateways.map((gateway) {
      return {"name": gateway.name, "ip": gateway.ip};
    }).toList();

    await box.put("gateway_list", data);
  }

  static List<GatewayModel> loadGateways() {
    final box = Hive.box(gatewayBox);

    List data = box.get("gateway_list", defaultValue: []);

    return data.map((item) {
      return GatewayModel(name: item["name"], ip: item["ip"]);
    }).toList();
  }

  static Future addLog(LogModel log) async {
    final box = Hive.box(logBox);

    List logs = box.get("logs", defaultValue: []);

    logs.add({
      "gatewayName": log.gatewayName,
      "gatewayIp": log.gatewayIp,
      "status": log.status,
      "datetime": log.datetime.toIso8601String(),
      "durationMinutes": log.durationMinutes,
    });

    await box.put("logs", logs);
  }

  static List<LogModel> loadLogs() {
    final box = Hive.box(logBox);

    List logs = box.get("logs", defaultValue: []);

    return logs.map((item) {
      return LogModel(
        gatewayName: item["gatewayName"],
        gatewayIp: item["gatewayIp"],
        status: item["status"],
        datetime: DateTime.parse(item["datetime"]),
        durationMinutes: item["durationMinutes"],
      );
    }).toList();
  }
}
