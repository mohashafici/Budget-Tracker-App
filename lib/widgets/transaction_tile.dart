import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/transaction_controller.dart';

class TransactionTile extends StatelessWidget {
  final String title;
  final double amount;
  final String type;
  final String id;

  const TransactionTile({
    super.key,
    required this.title,
    required this.amount,
    required this.type,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    final TransactionController transactionController = Get.find<TransactionController>();

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: Icon(
          type == "income" ? Icons.arrow_upward : Icons.arrow_downward,
          size: 30,
          color: type == "income" ? Colors.green : Colors.red,
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          type.toUpperCase(),
          style: TextStyle(color: type == "income" ? Colors.green : Colors.red),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "\$${amount.toStringAsFixed(2)}",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: type == "income" ? Colors.green : Colors.red),
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () => _editTransaction(context, transactionController),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                await transactionController.deleteTransaction(id);
              },
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Edit Transaction Dialog
  void _editTransaction(BuildContext context, TransactionController transactionController) {
    TextEditingController titleController = TextEditingController(text: title);
    TextEditingController amountController = TextEditingController(text: amount.toString());
    String selectedType = type;

    Get.dialog(
      AlertDialog(
        title: const Text("Edit Transaction"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleController, decoration: const InputDecoration(labelText: "Title")),
            TextField(controller: amountController, decoration: const InputDecoration(labelText: "Amount"), keyboardType: TextInputType.number),
            DropdownButton<String>(
              value: selectedType,
              items: const [
                DropdownMenuItem(value: "income", child: Text("Income")),
                DropdownMenuItem(value: "expense", child: Text("Expense")),
              ],
              onChanged: (value) {
                selectedType = value!;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              await transactionController.editTransaction(
                id,
                titleController.text,
                double.parse(amountController.text),
                "General",
                selectedType,
              );
              Get.back();
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}
