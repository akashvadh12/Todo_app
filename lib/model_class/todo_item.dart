import 'package:flutter/material.dart';

/// ------------------------------
/// Todo Item Model Class
/// ------------------------------
class TodoItem {
  // ------------------------------
  // Properties of a Todo Item
  // ------------------------------
  final String id; // Unique ID for the todo item
  final String text; // Description or title of the task
  final bool completed; // Task status (true = done, false = pending)
  final String category; // Category name (e.g., Work, Personal)
  final String categoryEmoji; // Emoji for category (for UI display)
  final Color categoryColor; // Color used to represent category

  // ------------------------------
  // Constructor
  // ------------------------------
  TodoItem({
    required this.id,
    required this.text,
    required this.completed,
    this.category = 'Daily Routine',
    this.categoryEmoji = '📅',
    required this.categoryColor,
  });

  // ------------------------------
  // Copy method to create updated version
  // ------------------------------
  TodoItem copyWith({
    String? id,
    String? text,
    bool? completed,
    String? category,
    String? categoryEmoji,
    Color? categoryColor,
  }) {
    return TodoItem(
      id: id ?? this.id,
      text: text ?? this.text,
      completed: completed ?? this.completed,
      category: category ?? this.category,
      categoryEmoji: categoryEmoji ?? this.categoryEmoji,
      categoryColor: categoryColor ?? this.categoryColor,
    );
  }

  // ------------------------------
  // Convert TodoItem to JSON format
  // ------------------------------
  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'completed': completed,
      'category': category,
      'categoryEmoji': categoryEmoji,
      'categoryColor': categoryColor.value, // Convert color to integer
    };
  }

  // ------------------------------
  // Create TodoItem from JSON format
  // ------------------------------
  factory TodoItem.fromJson(String id, Map<dynamic, dynamic> json) {
    return TodoItem(
      id: id,
      text: json['text'] ?? '',
      completed: json['completed'] ?? false,
      category: json['category'] ?? 'Daily Routine',
      categoryEmoji: json['categoryEmoji'] ?? '📅',
      categoryColor: Color(json['categoryColor'] ?? 0xFF6200EE),
    );
  }
}
