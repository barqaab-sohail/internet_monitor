import 'dart:async';

import 'package:get/get.dart';
import 'package:internet_monitor/services/storage_service.dart';

import '../models/gateway_model.dart';
import '../services/ping_service.dart';
import '../services/notification_service.dart';
import '../models/log_model.dart';
import '../services/storage_service.dart';

class GatewayController extends GetxController {
  RxList<GatewayModel> gateways = <GatewayModel>[].obs;

  Timer? timer;

  @override
  void onInit() {
    super.onInit();

     gateways.assignAll(
    StorageService.loadGateways(),
  );

    startMonitoring();
  }

  void addGateway(String name, String ip) {
  gateways.add(
    GatewayModel(
      name: name,
      ip: ip,
    ),
  );

  StorageService.saveGateways(gateways);
}

void removeGateway(int index) {
  gateways.removeAt(index);

  StorageService.saveGateways(gateways);
}

  void startMonitoring() {
  timer = Timer.periodic(
    const Duration(seconds: 10),
    (_) async {
      for (var gateway in gateways) {
        final result =
            await PingService.pingHost(
          gateway.ip,
        );

        bool previousStatus =
            gateway.isOnline;

        gateway.isOnline =
            result["success"];

        gateway.ping =
            result["ping"];

        // =========================
        // INTERNET DOWN
        // =========================

        if (previousStatus &&
            !gateway.isOnline) {
          gateway.downSince =
              DateTime.now();

          NotificationService
              .showNotification(
            "Internet Down",
            "${gateway.name} is offline",
          );

          await StorageService.addLog(
            LogModel(
              gatewayName:
                  gateway.name,
              gatewayIp: gateway.ip,
              status: "DOWN",
              datetime:
                  DateTime.now(),
            ),
          );
        }

        // =========================
        // INTERNET RESTORED
        // =========================

        if (!previousStatus &&
            gateway.isOnline) {
          int duration = 0;

          if (gateway.downSince != null) {
            duration = DateTime.now()
                .difference(
                  gateway.downSince!,
                )
                .inMinutes;
          }

          NotificationService
              .showNotification(
            "Internet Restored",
            "${gateway.name} is online",
          );

          await StorageService.addLog(
            LogModel(
              gatewayName:
                  gateway.name,
              gatewayIp: gateway.ip,
              status: "UP",
              datetime:
                  DateTime.now(),
              durationMinutes:
                  duration,
            ),
          );

          gateway.downSince = null;
        }

        gateways.refresh();
      }
    },
  );
}

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }
}