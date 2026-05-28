import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/gateway_controller.dart';
import '../controllers/navigation_controller.dart';

import 'add_gateway_dialog.dart';
import 'gateway_screen.dart';
import 'report_screen.dart';
import 'log_screen.dart';
import 'settings_screen.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  final GatewayController controller = Get.put(GatewayController());

  final NavigationController navController = Get.put(NavigationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f7fb),

      body: Row(
        children: [
          // =========================
          // SIDEBAR
          // =========================
          Container(
            width: 260,

            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff02142b), Color(0xff0a2a57)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),

            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),

                child: Column(
                  children: [
                    const SizedBox(height: 30),

                    // LOGO
                    Container(
                      width: 170,
                      height: 170,

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),

                        border: Border.all(color: Colors.white24),

                        image: const DecorationImage(
                          image: AssetImage("assets/images/logo_new_1.png"),

                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      "Internet Monitor",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      "v1.0.0",
                      style: TextStyle(color: Colors.white70),
                    ),

                    const SizedBox(height: 30),

                    // MENU ITEMS
                    Obx(
                      () => _menuItem(
                        Icons.dashboard,
                        "Dashboard",
                        navController.selectedIndex.value == 0,
                        () {
                          navController.changePage(0);
                        },
                      ),
                    ),

                    Obx(
                      () => _menuItem(
                        Icons.router,
                        "Gateways",
                        navController.selectedIndex.value == 1,
                        () {
                          navController.changePage(1);
                        },
                      ),
                    ),

                    Obx(
                      () => _menuItem(
                        Icons.bar_chart,
                        "Reports",
                        navController.selectedIndex.value == 2,
                        () {
                          navController.changePage(2);
                        },
                      ),
                    ),

                    Obx(
                      () => _menuItem(
                        Icons.history,
                        "Logs",
                        navController.selectedIndex.value == 3,
                        () {
                          navController.changePage(3);
                        },
                      ),
                    ),

                    Obx(
                      () => _menuItem(
                        Icons.settings,
                        "Settings",
                        navController.selectedIndex.value == 4,
                        () {
                          navController.changePage(4);
                        },
                      ),
                    ),

                    const SizedBox(height: 40),

                    // STATUS BOX
                    Container(
                      margin: const EdgeInsets.all(20),

                      padding: const EdgeInsets.all(15),

                      decoration: BoxDecoration(
                        color: Colors.white10,

                        borderRadius: BorderRadius.circular(15),
                      ),

                      child: const Row(
                        children: [
                          CircleAvatar(
                            radius: 6,
                            backgroundColor: Colors.green,
                          ),

                          SizedBox(width: 10),

                          Expanded(
                            child: Text(
                              "Monitoring Active",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),

          // =========================
          // MAIN CONTENT
          // =========================
          Expanded(
            child: Obx(() {
              switch (navController.selectedIndex.value) {
                case 1:
                  return const GatewayScreen();

                case 2:
                  return ReportScreen();

                case 3:
                  return const LogScreen();

                case 4:
                  return const SettingsScreen();

                default:
                  return _dashboardContent();
              }
            }),
          ),
        ],
      ),
    );
  }

  // =========================
  // DASHBOARD CONTENT
  // =========================

  Widget _dashboardContent() {
    return Padding(
      padding: const EdgeInsets.all(25),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          // HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    "Dashboard",
                    style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold),
                  ),

                  SizedBox(height: 5),

                  Text(
                    "Monitor your internet connections in real-time",
                    style: TextStyle(color: Colors.black54),
                  ),
                ],
              ),

              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,

                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                ),

                onPressed: () {
                  Get.dialog(AddGatewayDialog());
                },

                icon: const Icon(Icons.add, color: Colors.white),

                label: const Text(
                  "Add Gateway",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),

          const SizedBox(height: 25),

          // SUMMARY CARDS
          Obx(() {
            return Row(
              children: [
                _summaryCard(
                  "Total Gateways",
                  controller.gateways.length.toString(),
                  Icons.router,
                  Colors.green,
                ),

                const SizedBox(width: 20),

                _summaryCard(
                  "Online",
                  controller.gateways
                      .where((e) => e.isOnline)
                      .length
                      .toString(),
                  Icons.check_circle,
                  Colors.green,
                ),

                const SizedBox(width: 20),

                _summaryCard(
                  "Offline",
                  controller.gateways
                      .where((e) => !e.isOnline)
                      .length
                      .toString(),
                  Icons.cancel,
                  Colors.red,
                ),
              ],
            );
          }),

          const SizedBox(height: 25),

          // GATEWAYS TABLE
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius: BorderRadius.circular(20),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      const Text(
                        "Internet Gateways",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      IconButton(
                        onPressed: () {
                          navController.changePage(2);
                        },

                        icon: const Icon(Icons.history),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Expanded(
                    child: Obx(() {
                      return ListView.builder(
                        itemCount: controller.gateways.length,

                        itemBuilder: (_, index) {
                          final gateway = controller.gateways[index];

                          return Container(
                            margin: const EdgeInsets.only(bottom: 15),

                            padding: const EdgeInsets.all(15),

                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),

                              border: Border.all(color: Colors.black12),
                            ),

                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    gateway.name,

                                    style: const TextStyle(
                                      fontSize: 18,

                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),

                                Expanded(flex: 2, child: Text(gateway.ip)),

                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),

                                    decoration: BoxDecoration(
                                      color: gateway.isOnline
                                          ? Colors.green.withValues(alpha: 0.1)
                                          : Colors.red.withValues(alpha: 0.1),

                                      borderRadius: BorderRadius.circular(20),
                                    ),

                                    child: Text(
                                      gateway.isOnline ? "ONLINE" : "OFFLINE",

                                      textAlign: TextAlign.center,

                                      style: TextStyle(
                                        color: gateway.isOnline
                                            ? Colors.green
                                            : Colors.red,

                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),

                                Expanded(
                                  child: Text(
                                    gateway.isOnline
                                        ? "${gateway.ping} ms"
                                        : "Timeout",
                                  ),
                                ),

                                IconButton(
                                  onPressed: () {
                                    controller.removeGateway(index);
                                  },

                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  // MENU ITEM
  // =========================

  Widget _menuItem(
    IconData icon,
    String title,
    bool active,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,

      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),

        decoration: BoxDecoration(
          color: active ? Colors.blue : Colors.transparent,

          borderRadius: BorderRadius.circular(15),
        ),

        child: ListTile(
          leading: Icon(icon, color: Colors.white),

          title: Text(title, style: const TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  // =========================
  // SUMMARY CARD
  // =========================

  Widget _summaryCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(20),
        ),

        child: Row(
          children: [
            CircleAvatar(
              radius: 28,

              backgroundColor: color.withValues(alpha: 0.1),

              child: Icon(icon, color: color, size: 30),
            ),

            const SizedBox(width: 15),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(title, style: const TextStyle(color: Colors.black54)),

                const SizedBox(height: 5),

                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
