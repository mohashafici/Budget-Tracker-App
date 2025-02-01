import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../controllers/transaction_controller.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final transactionController = Get.find<TransactionController>();

    double totalIncome = transactionController.transactions
        .where((t) => t["type"] == "income")
        .fold(0.0, (sum, t) => sum + (t["amount"] as num).toDouble());

    double totalExpense = transactionController.transactions
        .where((t) => t["type"] == "expense")
        .fold(0.0, (sum, t) => sum + (t["amount"] as num).toDouble());

    double netBalance = totalIncome - totalExpense;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Stats", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Month Selector
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: ["Jan", "Feb", "Mar", "Apr", "May", "Jun"]
                    .map((month) => _monthButton(month, context))
                    .toList(),
              ),
            ),
            const SizedBox(height: 20),

            // 🔹 Net Balance
            Text("Net Balance", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[600])),
            Text(
              "\$${netBalance.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // 🔹 Line Chart (Clean & Dynamic)
            SizedBox(
              height: 150,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: transactionController.transactions
                          .asMap()
                          .entries
                          .map((entry) => FlSpot(entry.key.toDouble(), (entry.value["amount"] as num).toDouble()))
                          .toList(),
                      isCurved: true,
                      color: Colors.pinkAccent,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 🔹 Income & Expense Cards
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _summaryCard("Income", totalIncome, Colors.blue),
                _summaryCard("Expense", totalExpense, Colors.red),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Month Button Widget
  Widget _monthButton(String label, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ElevatedButton(
        onPressed: () {
          // Handle month selection
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.pinkAccent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(label, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  // 🔹 Income & Expense Summary Card
  Widget _summaryCard(String title, double amount, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      width: 150,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text(
            "\$${amount.toStringAsFixed(2)}",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }
}
