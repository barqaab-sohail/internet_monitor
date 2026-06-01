import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_monitor/models/gateway_report.dart';

import '../models/log_model.dart';
import '../services/storage_service.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

List<GatewayReport> reports = [];

class _ReportScreenState extends State<ReportScreen> {
  List<LogModel> logs = [];

  @override
  void initState() {
    super.initState();

    loadLogs();
  }

  void loadLogs() {
    logs = StorageService.loadLogs();

    reports = StorageService.generateReports();

    setState(() {});
  }

  Future clearLogs() async {
    bool? confirm = await Get.dialog(
      AlertDialog(
        title: const Text("Clear Logs"),

        content: const Text("Are you sure you want to delete all logs?"),

        actions: [
          TextButton(
            onPressed: () {
              Get.back(result: false);
            },

            child: const Text("Cancel"),
          ),

          ElevatedButton(
            onPressed: () {
              Get.back(result: true);
            },

            child: const Text("Clear"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await StorageService.clearLogs();

      loadLogs();

      Get.snackbar(
        "Success",
        "All logs cleared",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25),

      child: Container(
        padding: const EdgeInsets.all(20),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(20),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                const Text(
                  "Internet Reports",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),

                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),

                  onPressed: clearLogs,

                  icon: const Icon(Icons.delete, color: Colors.white),

                  label: const Text(
                    "Clear Logs",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(15),

              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(10),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  const Text(
                    "Summary",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 15),

                  DataTable(
                    columns: const [
                      DataColumn(label: Text("Gateway")),

                      DataColumn(label: Text("Down Count")),

                      DataColumn(label: Text("Total Downtime")),

                      DataColumn(label: Text("Avg Downtime")),
                    ],

                    rows: reports.map((report) {
                      final avg = report.downCount == 0
                          ? 0
                          : report.totalDowntime / report.downCount;

                      return DataRow(
                        cells: [
                          DataCell(Text(report.gatewayName)),

                          DataCell(Text(report.downCount.toString())),

                          DataCell(Text("${report.totalDowntime} min")),

                          DataCell(Text("${avg.toStringAsFixed(1)} min")),
                        ],
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            // TABLE HEADER
            Container(
              padding: const EdgeInsets.all(15),

              decoration: BoxDecoration(
                color: Colors.grey.shade100,

                borderRadius: BorderRadius.circular(10),
              ),

              child: const Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      "Time",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),

                  Expanded(
                    flex: 2,
                    child: Text(
                      "Gateway",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),

                  Expanded(
                    flex: 2,
                    child: Text(
                      "IP Address",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),

                  Expanded(
                    child: Text(
                      "Status",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),

                  Expanded(
                    child: Text(
                      "Duration",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // LOGS
            Expanded(
              child: logs.isEmpty
                  ? const Center(
                      child: Text(
                        "No logs found",
                        style: TextStyle(fontSize: 18, color: Colors.black54),
                      ),
                    )
                  : ListView.builder(
                      itemCount: logs.length,

                      itemBuilder: (_, index) {
                        final log = logs[index];

                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),

                          padding: const EdgeInsets.all(15),

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),

                            border: Border.all(color: Colors.black12),
                          ),

                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(log.datetime.toString()),
                              ),

                              Expanded(flex: 2, child: Text(log.gatewayName)),

                              Expanded(flex: 2, child: Text(log.gatewayIp)),

                              Expanded(
                                child: Text(
                                  log.status,

                                  style: TextStyle(
                                    color: log.status == "DOWN"
                                        ? Colors.red
                                        : Colors.green,

                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                              Expanded(
                                child: Text(
                                  log.durationMinutes > 0
                                      ? "${log.durationMinutes} min"
                                      : "-",
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
