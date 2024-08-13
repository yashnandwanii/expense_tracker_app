import 'package:expense_tracker_app/widgets/analysis.dart';
import 'package:expense_tracker_app/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker_app/models/expense.dart';
import 'package:expense_tracker_app/widgets/new_expense.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
        title: 'Samose',
        amount: 50,
        date: DateTime.now(),
        category: Category.food),
    Expense(
        title: 'Burger',
        amount: 100,
        date: DateTime.now(),
        category: Category.food),
    Expense(
        title: 'Udemy Course',
        amount: 3000,
        date: DateTime.now(),
        category: Category.education),
  ];

  int _totalSpent() {
    int total = 0;
    for (var expense in _registeredExpenses) {
      total += expense.amount.toInt();
    }
    return total;
  }

  int _income() {
    int total = 5000;
    return total;
  }

  int _balance() {
    return _income() - _totalSpent();
  }

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) {
        return NewExpense(onAddExpense: _addExoense);
      },
    );
  }

  void _addExoense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final removedIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        content: const Text('Expense removed'),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(removedIndex, expense);
            });
          },
        ),
      ),
    );
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = const Center(
      child: Text('No expenses added yet'),
    );

    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registeredExpenses,
        onRemoveExpense: _removeExpense,
      );
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(176, 41, 47, 59),
      appBar: AppBar(
        title: Row(
          children: [
            const Text(
              'Good Morning, User!',
              style: TextStyle(color: Colors.white),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {
                // Handle profile
              },
              icon: const Icon(
                Icons.person,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          // Home Screen (Expenses)
          Column(
            children: [
              const SizedBox(height: 10),
              Row(
                children: [
                  const SizedBox(width: 10),
                  const Text('This month',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      // Handle calendar
                    },
                    icon: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Handle expenses
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                          const Color.fromARGB(255, 117, 58, 78)),
                      padding: WidgetStateProperty.all(
                        const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 10,
                        ),
                      ),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Spending',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          '₹ ${_totalSpent()}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                          const Color.fromARGB(255, 80, 137, 82)),
                      padding: WidgetStateProperty.all(
                        const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 10,
                        ),
                      ),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Income',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          '₹ ${_income()}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {},
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                      const Color.fromARGB(255, 50, 65, 73)),
                  padding: WidgetStateProperty.all(
                    const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 10,
                    ),
                  ),
                ),
                child: Text(
                  'Balance: ₹${_balance()}',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 10),
              const Row(
                children: [
                  SizedBox(width: 5),
                  Text(
                    'Recent Transactions',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Text(
                    'View All',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 5),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ExpensesList(
                    expenses: _registeredExpenses,
                    onRemoveExpense: _removeExpense),
              ),
              const SizedBox(height: 10),
              const Row(
                children: [
                  SizedBox(width: 10),
                  Text('Monthly Budget',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  Spacer(),
                  Text('Edit Budget',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      )),
                ],
              ),
              const SizedBox(height: 10),
              Column(
                children: [
                  const Text(
                    'Budget Left',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  Text('₹${_totalSpent()} of ₹5000',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  LinearProgressIndicator(
                    value: _totalSpent() / 5000,
                    backgroundColor: const Color.fromARGB(255, 50, 65, 73),
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                ],
              ),
            ],
          ),

          // Analysis Screen
          const AnalysisScreen(),
        ],
      ),
      bottomNavigationBar: Stack(
        children: [
          BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart),
                label: 'Analysis',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white70,
            backgroundColor: const Color.fromARGB(255, 5, 32, 46),
            onTap: _onItemTapped,
          ),
          Center(
            heightFactor: 0.5,
            child: GestureDetector(
              onTap: () {
                _openAddExpenseOverlay();
              },
              child: Container(
                width: 70,
                height: 70,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.add,
                  color: Colors.black,
                  size: 36,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
