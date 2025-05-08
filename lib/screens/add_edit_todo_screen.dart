import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/model_class/todo_item.dart';
import 'package:todo_app/provider/todo_provider.dart';


class AddEditTodoScreen extends StatefulWidget {
  final TodoItem? todo;

  const AddEditTodoScreen({Key? key, this.todo}) : super(key: key);

  @override
  _AddEditTodoScreenState createState() => _AddEditTodoScreenState();
}

class _AddEditTodoScreenState extends State<AddEditTodoScreen> {
  final TextEditingController _textController = TextEditingController();

  String _selectedCategory = 'Daily Routine';
  String _selectedCategoryEmoji = '📅';
  Color _selectedCategoryColor = Colors.purple;

  final Map<String, Map<String, dynamic>> _categories = {
    'Personal Productivity': {
      'emoji': '✅',
      'color': Colors.green,
      'subcategories': [
        '📚 Study',
        '📖 Reading',
        '🏋️‍♂️ Exercise / Workout',
        '🧘‍♀️ Meditation',
        '📓 Journaling',
        '🧠 Learning a New Skill',
      ],
    },
    'Errands & Shopping': {
      'emoji': '🛍️',
      'color': Colors.amber,
      'subcategories': [
        '🛒 Grocery Shopping',
        '👗 Clothing',
        '📱 Electronics',
        '🧹 Household Items',
        '💊 Pharmacy / Medicines',
        '🎁 Gifts',
      ],
    },
    'Entertainment & Leisure': {
      'emoji': '🎬',
      'color': Colors.deepOrange,
      'subcategories': [
        '🎥 Movies to Watch',
        '📺 TV Shows / Web Series',
        '🎧 Music / Albums to Listen',
        '🎮 Games to Play',
        '🎟️ Events / Concerts',
      ],
    },
    'Home & Family': {
      'emoji': '🏠',
      'color': Colors.lightBlue,
      'subcategories': [
        '🧽 Cleaning / Organizing',
        '🍽️ Cooking / Meal Prep',
        '🧺 Laundry',
        '🔧 Home Repairs',
        '👨‍👩‍👧 Family Time',
        '🐶 Pet Care',
      ],
    },
    'Work & Career': {
      'emoji': '💼',
      'color': Colors.indigo,
      'subcategories': [
        '🖥️ Office Work',
        '📆 Meetings / Appointments',
        '📧 Emails / Follow-ups',
        '📊 Projects / Deadlines',
        '📝 Resume / Job Search',
      ],
    },
    'Finance & Budgeting': {
      'emoji': '💰',
      'color': Colors.teal,
      'subcategories': [
        '💸 Pay Bills',
        '🧾 Budget Planning',
        '📉 Track Expenses',
        '📈 Investments',
      ],
    },
    'Travel & Outings': {
      'emoji': '🚗',
      'color': Colors.cyan,
      'subcategories': [
        '🧳 Trip Planning',
        '📦 Packing Checklist',
        '🗺️ Places to Visit',
        '🎫 Book Tickets / Hotels',
      ],
    },
    'Health & Wellness': {
      'emoji': '❤️',
      'color': Colors.pink,
      'subcategories': [
        '🩺 Doctor Appointments',
        '💊 Medication',
        '🥗 Diet Tracking',
        '🧠 Therapy / Mental Health',
      ],
    },
    'Daily Routine': {
      'emoji': '📅',
      'color': Colors.purple,
      'subcategories': [
        '🌅 Morning Routine',
        '🌙 Night Routine',
        '⏰ Reminders',
      ],
    },
    'Goals & Habits': {
      'emoji': '🎯',
      'color': Colors.red,
      'subcategories': [
        '🥅 Short-Term Goals',
        '🎯 Long-Term Goals',
        '✅ Habit Tracker',
      ],
    },
  };

  @override
  void initState() {
    super.initState();
    if (widget.todo != null) {
      _textController.text = widget.todo!.text;
      _selectedCategory = widget.todo!.category;
      _selectedCategoryEmoji = widget.todo!.categoryEmoji;
      _selectedCategoryColor = widget.todo!.categoryColor;
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _selectCategory() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.category, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            const Text('Select Category'),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: ListView(
            children: _categories.entries.map((entry) {
              String category = entry.key;
              String emoji = entry.value['emoji'];
              List<String> subcategories = List<String>.from(entry.value['subcategories']);

              return ExpansionTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: entry.value['color'].withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(child: Text(emoji, style: const TextStyle(fontSize: 20))),
                ),
                title: Text(category),
                children: subcategories.map((subcat) {
                  final regex = RegExp(
                    r'^(\p{Emoji_Presentation}|\p{Emoji}\uFE0F)?\s*(.*)',
                    unicode: true,
                  );
                  final match = regex.firstMatch(subcat);
                  String subcatEmoji = '';
                  String subcatName = subcat;
                  if (match != null && match.groupCount >= 2) {
                    subcatEmoji = match.group(1) ?? '';
                    subcatName = match.group(2) ?? subcat;
                  }
                  return ListTile(
                    title: Text('$subcatEmoji $subcatName'),
                    onTap: () {
                      setState(() {
                        _selectedCategory = subcatName;
                        _selectedCategoryEmoji = emoji;
                        _selectedCategoryColor = entry.value['color'];
                      });
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.todo != null;
    final todoProvider = Provider.of<TodoProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Task' : 'Add Task')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                labelText: 'Task',
                prefixIcon: Icon(Icons.edit),
              ),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: _selectCategory,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _selectedCategoryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _selectedCategoryColor.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Row(
                        children: [
                          Text(_selectedCategoryEmoji, style: const TextStyle(fontSize: 18)),
                          const SizedBox(width: 8),
                          Flexible(child: Text(_selectedCategory, overflow: TextOverflow.ellipsis)),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_drop_down, color: _selectedCategoryColor),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL')),
                FilledButton(
                  onPressed: () async {
                    final text = _textController.text.trim();
                    if (text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a task')));
                      return;
                    }
                    try {
                      if (isEditing) {
                        final updatedTodo = widget.todo!.copyWith(
                          text: text,
                          category: _selectedCategory,
                          categoryEmoji: _selectedCategoryEmoji,
                          categoryColor: _selectedCategoryColor,
                        );
                        await todoProvider.updateTodo(updatedTodo);
                      } else {
                        final newTodo = TodoItem(
                          id: '',
                          text: text,
                          completed: false,
                          category: _selectedCategory,
                          categoryEmoji: _selectedCategoryEmoji,
                          categoryColor: _selectedCategoryColor,
                        );
                        await todoProvider.addTodo(newTodo);
                      }
                      if (mounted) Navigator.pop(context);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to save task: $e')));
                    }
                  },
                  child: Text(isEditing ? 'SAVE' : 'ADD'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
