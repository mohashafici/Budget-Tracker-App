import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/transaction_controller.dart' as controller; // ✅ Use alias
import '../widgets/transaction_tile.dart'; // ✅ Import the correct file

class TransactionListScreen extends StatelessWidget {
  const TransactionListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final transactionController = Get.find<controller.TransactionController>(); // ✅ Use alias

    return Column(
      children: [
        Expanded(
          child: Obx(() {
            if (transactionController.transactions.isEmpty) {
              return const Center(child: Text("No transactions available", style: TextStyle(fontSize: 16)));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: transactionController.transactions.length,
              itemBuilder: (context, index) {
                var transaction = transactionController.transactions[index];
                return TransactionTile(
                  title: transaction["title"],
                  amount: (transaction["amount"] as num).toDouble(),
                  type: transaction["type"],
                  id: transaction["_id"],
                );
              },
            );
          }),
        ),
      ],
    );
  }
}
