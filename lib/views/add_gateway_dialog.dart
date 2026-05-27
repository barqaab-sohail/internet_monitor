import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/gateway_controller.dart';

class AddGatewayDialog extends StatelessWidget {
  AddGatewayDialog({super.key});

  final TextEditingController nameController =
      TextEditingController();

  final TextEditingController ipController =
      TextEditingController();

  final GatewayController controller =
      Get.find<GatewayController>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add Gateway"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: "Gateway Name",
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 15),

          TextField(
            controller: ipController,
            decoration: const InputDecoration(
              labelText: "IP Address",
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: const Text("Cancel"),
        ),

        ElevatedButton(
          onPressed: () {
            if (nameController.text.isEmpty ||
                ipController.text.isEmpty) {
              Get.snackbar(
                "Error",
                "Please fill all fields",
              );

              return;
            }

            controller.addGateway(
              nameController.text,
              ipController.text,
            );

            Get.back();
          },
          child: const Text("Save"),
        ),
      ],
    );
  }
}