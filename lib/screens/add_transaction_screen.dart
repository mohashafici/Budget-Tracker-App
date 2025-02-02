import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/transaction_controller.dart';

class AddTransactionScreen extends StatelessWidget {
  AddTransactionScreen({super.key});
//try
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final RxString _selectedCategory = "Food".obs;
  final RxString _selectedType = "Income".obs;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // ✅ Form key for validation

  final TransactionController transactionController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Transaction"), backgroundColor: Colors.pinkAccent),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form( // ✅ Wrap with Form for validation
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: "Title"),
                validator: (value) => value!.isEmpty ? "Title is required" : null,
              ),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Amount"),
                validator: (value) => value!.isEmpty ? "Amount is required" : null,
              ),
              const SizedBox(height: 10),
              
              // ✅ Category Dropdown
              Obx(() => DropdownButtonFormField<String>(
                    value: _selectedCategory.value,
                    decoration: const InputDecoration(labelText: "Category"),
                    items: ["Food", "Transport", "Entertainment", "Other"]
                        .map((category) => DropdownMenuItem(value: category, child: Text(category)))
                        .toList(),
                    onChanged: (value) => _selectedCategory.value = value!,
                  )),
              
              // ✅ Type Dropdown
              Obx(() => DropdownButtonFormField<String>(
                    value: _selectedType.value,
                    decoration: const InputDecoration(labelText: "Type"),
                    items: ["Income", "Expense"]
                        .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                        .toList(),
                    onChanged: (value) => _selectedType.value = value!,
                  )),
              
              const SizedBox(height: 20),
              
            ElevatedButton(
  onPressed: () async {
    if (_formKey.currentState!.validate()) {
      try {
        await transactionController.addTransaction(
          _titleController.text.trim(),
          double.parse(_amountController.text.trim()),
          _selectedCategory.value.trim(),
          _selectedType.value.toLowerCase().trim(),  // Fixes issue
        );
        Get.offNamed("/transactions");  // Ensure this route is correct in your app
      } catch (e) {
        Get.snackbar("Error", "Failed to add transaction", backgroundColor: Colors.red, colorText: Colors.white);
      }
    }
  },
  child: const Text("Add Transaction"),
),

            ],
          ),
        ),
      ),
    );
  }
}
