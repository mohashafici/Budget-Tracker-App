import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/transaction_controller.dart';
import '../widgets/transaction_tile.dart';

class TransactionSearchDelegate extends SearchDelegate {
  final transactionController = Get.find<TransactionController>();

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = transactionController.filteredTransactions.where(
      (transaction) => transaction["title"].toLowerCase().contains(query.toLowerCase()),
    );

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        var transaction = results.elementAt(index);
        return TransactionTile(
          title: transaction["title"],
          amount: (transaction["amount"] as num).toDouble(),
          type: transaction["type"],
          id: transaction["_id"],
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = transactionController.filteredTransactions.where(
      (transaction) => transaction["title"].toLowerCase().contains(query.toLowerCase()),
    );

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        var transaction = suggestions.elementAt(index);
        return ListTile(
          title: Text(transaction["title"]),
          onTap: () {
            query = transaction["title"];
            showResults(context);
          },
        );
      },
    );
  }
}
