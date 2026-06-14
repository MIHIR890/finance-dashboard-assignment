import 'package:flutter/material.dart';

class TransactionItemModel {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String category;
  final String time;
  final String amount;
  final DateTime date;

  const TransactionItemModel({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.category,
    required this.time,
    required this.amount,
    required this.date,
  });
}