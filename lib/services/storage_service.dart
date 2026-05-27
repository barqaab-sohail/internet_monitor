import 'package:hive_flutter/hive_flutter.dart';

import '../models/gateway_model.dart';
import '../models/log_model.dart';

class StorageService {
  static const String gatewayBox = "gateways";
  static const String logBox = "logs";

  static Future init() async {
    await Hive.initFlutter();

    await Hive.openBox(gatewayBox);
    await Hive.openBox(logBox);
  }


  static Future clearLogs() async {
  final box = Hive.box(logBox);

  await box.put("logs", []);
}


  // ========================
  // GATEWAYS
  // ========================

  static Future saveGateways(
      List<GatewayModel> gateways) async {
    final box = Hive.box(gatewayBox);

    List<Map<String, dynamic>> data =
        gateways.map((gateway) {
      return {
        "name": gateway.name,
        "ip": gateway.ip,
      };
    }).toList();

    await box.put("gateway_list", data);
  }

  static List<GatewayModel> loadGateways() {
    final box = Hive.box(gatewayBox);

    List data =
        box.get("gateway_list", defaultValue: []);

    return data.map((item) {
      return GatewayModel(
        name: item["name"],
        ip: item["ip"],
      );
    }).toList();
  }

  // ========================
  // LOGS
  // ========================

  static Future addLog(LogModel log) async {
    final box = Hive.box(logBox);

    List logs =
        box.get("logs", defaultValue: []);

    logs.add({
      "gatewayName": log.gatewayName,
      "gatewayIp": log.gatewayIp,
      "status": log.status,
      "datetime":
          log.datetime.toIso8601String(),
      "durationMinutes":
          log.durationMinutes,
    });

    await box.put("logs", logs);
  }

  static List<LogModel> loadLogs() {
    final box = Hive.box(logBox);

    List logs =
        box.get("logs", defaultValue: []);

    return logs.map((item) {
      return LogModel(
        gatewayName: item["gatewayName"],
        gatewayIp: item["gatewayIp"],
        status: item["status"],
        datetime:
            DateTime.parse(item["datetime"]),
        durationMinutes:
            item["durationMinutes"],
      );
    }).toList();
  }
}