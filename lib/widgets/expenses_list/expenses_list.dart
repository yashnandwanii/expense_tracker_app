import 'package:expense_tracker_app/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList(
      {super.key, required this.expenses, required this.onRemoveExpense,});

  final List<Expense> expenses;

  final void Function(Expense expense) onRemoveExpense;

  get expenseAmounts{
    double totalAmount = 0;
    for(int i = 0; i < expenses.length; i++){
      totalAmount += expenses[i].amount;
    }
    return totalAmount;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        final formattedDate =
            DateFormat('d MMM yy').format(expenses[index].date);
        return Dismissible(
          key: ValueKey(expenses[index]),
          onDismissed: (direction) {
            onRemoveExpense(expenses[index]);
          },
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Icon(
              Icons.delete,
              color: Colors.white,
              size: 40,
            ),
          ),
          child: Card(
            color: const Color.fromARGB(255, 50, 65, 73),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Icon(
                  categoryIcons[expenses[index].category],
                  color: Colors.orange,
                  shadows: const [
                    BoxShadow(
                      color: Colors.orange,
                      blurRadius: 5,
                    ),
                  ],
                ),
              ),
              title: Text(
                '₹${expenses[index].amount.toStringAsFixed(2)}',
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
              subtitle: Text(
                expenses[index].title,
                style: const TextStyle(color: Colors.white),
              ),
              trailing: Text(
                formattedDate,
                style: const TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
          ),
        );
      },
    );
  }
}
