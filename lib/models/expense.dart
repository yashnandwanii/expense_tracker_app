import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

const uuid = Uuid();

enum Category { food, education, health, entertainment, other }

const categoryIcons = {
  Category.food: Icons.fastfood,
  Category.education: Icons.school,
  Category.health: Icons.local_hospital,
  Category.entertainment: Icons.movie,
  Category.other: Icons.category,
};

class Expense {
  Expense(
      {required this.title,
      required this.amount,
      required this.date,
      required this.category})
      : id = uuid.v4();

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  String get formattedDate {
    return DateFormat('d MMM yy').format(date);
  }
}
