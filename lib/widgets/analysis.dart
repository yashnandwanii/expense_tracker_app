import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker_app/models/expense.dart';

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
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
    return _registeredExpenses.fold(
        0, (sum, item) => sum + item.amount.toInt());
  }

  int _income = 5000; // Allow this to be dynamic in a real app.

  int _balance() {
    return _income - _totalSpent();
  }

  List<PieChartSectionData> _getPieChartSections() {
    Map<Category, double> categorySpending = {};

    for (var expense in _registeredExpenses) {
      categorySpending.update(
          expense.category, (value) => value + expense.amount,
          ifAbsent: () => expense.amount);
    }

    return categorySpending.entries.map((entry) {
      return PieChartSectionData(
        color: _getCategoryColor(entry.key),
        value: entry.value,
        title: entry.value.toStringAsFixed(0),
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xffffffff),
        ),
      );
    }).toList();
  }

  Color _getCategoryColor(Category category) {
    switch (category) {
      case Category.food:
        return Colors.orange;
      case Category.education:
        return Colors.blue;
      case Category.health:
        return Colors.red;
      case Category.entertainment:
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text(
          'Analysis',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAnalysisCard(
                    title: 'Spending',
                    value: '₹ ${_totalSpent()}',
                    color: const Color.fromARGB(255, 117, 58, 78)),
                _buildAnalysisCard(
                    title: 'Income',
                    value: '₹ $_income',
                    color: const Color.fromARGB(255, 80, 137, 82)),
                _buildAnalysisCard(
                    title: 'Balance',
                    value: '₹ ${_balance()}',
                    color: const Color.fromARGB(255, 60, 106, 184)),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Spending Breakdown',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildPieChart(),
            const SizedBox(height: 16),
            const Text(
              'Budget',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildBudgetTracker(),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalysisCard(
      {required String title, required String value, required Color color}) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildPieChart() {
    return SizedBox(
      height: 200,
      child: PieChart(
        PieChartData(
          sections: _getPieChartSections(),
          centerSpaceRadius: 40,
          borderData: FlBorderData(show: false),
          sectionsSpace: 0,
          pieTouchData: PieTouchData(
            touchCallback: (FlTouchEvent event, pieTouchResponse) {
              setState(() {
                if (!event.isInterestedForInteractions ||
                    pieTouchResponse == null ||
                    pieTouchResponse.touchedSection == null) {
                  return;
                }
                final touchedIndex =
                    pieTouchResponse.touchedSection!.touchedSectionIndex;

                // Highlight the touched section
                _getPieChartSections().asMap().forEach((index, section) {
                  if (index == touchedIndex) {
                    section.copyWith(
                      radius: 60, // Enlarge the touched section
                      titleStyle: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  }
                });
              });
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBudgetTracker() {
    int totalBudget = _income;
    int remainingBudget = totalBudget - _totalSpent();
    double progress = _totalSpent() / totalBudget;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Remaining Budget: ₹$remainingBudget',
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey.shade700,
          color: progress > 0.75 ? Colors.red : Colors.green,
          minHeight: 10,
        ),
        const SizedBox(height: 8),
        Text(
          progress > 0.75
              ? 'Warning: You are close to exceeding your budget!'
              : 'You are within your budget',
          style: TextStyle(
            color: progress > 0.75 ? Colors.red : Colors.green,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
