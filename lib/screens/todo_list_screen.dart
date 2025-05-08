import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/model_class/todo_item.dart';
import 'package:todo_app/provider/todo_provider.dart';
import 'add_edit_todo_screen.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({Key? key}) : super(key: key);

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  String? _currentFilter;
  bool _showCompletedOnly = false;

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
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      setState(() {
        _showCompletedOnly = _tabController.index == 1;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<TodoItem> _filterTodos(List<TodoItem> todos) {
    return todos.where((todo) {
      final matchesSearch =
          _searchQuery.isEmpty ||
          todo.text.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCompletion = !_showCompletedOnly || todo.completed;
      bool matchesCategory = true;
      if (_currentFilter != null) {
        if (todo.category == _currentFilter) {
          matchesCategory = true;
        } else if (_categories.containsKey(_currentFilter)) {
          final subcats = List<String>.from(
            _categories[_currentFilter]!['subcategories'],
          );
          matchesCategory = subcats.any((subcat) {
            final regex = RegExp(
              r'^(\p{Emoji_Presentation}|\p{Emoji}\uFE0F)?\s*(.*)',
              unicode: true,
            );
            final match = regex.firstMatch(subcat);
            final subcatName = match?.group(2) ?? subcat;
            return todo.category == subcatName;
          });
        } else {
          matchesCategory = false;
        }
      }
      return matchesSearch && matchesCompletion && matchesCategory;
    }).toList();
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String tempSearch = _searchQuery;
        return AlertDialog(
          title: const Text('Search Tasks'),
          content: TextField(
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Enter search term',
              prefixIcon: Icon(Icons.search),
            ),
            controller: TextEditingController(text: _searchQuery),
            onChanged: (value) => tempSearch = value,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _searchQuery = tempSearch;
                });
                Navigator.pop(context);
              },
              child: const Text('SEARCH'),
            ),
          ],
        );
      },
    );
  }

  void _showFilterDialog() {
    String? tempFilter = _currentFilter;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateModal) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Filter Tasks',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      FilterChip(
                        label: const Text('All'),
                        selected: tempFilter == null,
                        onSelected: (bool selected) {
                          setStateModal(() {
                            tempFilter = null;
                          });
                        },
                      ),
                      ..._categories.keys.map((cat) {
                        final color = _categories[cat]!['color'] as Color;
                        final emoji = _categories[cat]!['emoji'] as String;
                        return FilterChip(
                          avatar: CircleAvatar(
                            backgroundColor: color.withOpacity(0.2),
                            child: Text(emoji),
                          ),
                          label: Text(cat),
                          selected: tempFilter == cat,
                          onSelected: (bool selected) {
                            setStateModal(() {
                              tempFilter = selected ? cat : null;
                            });
                          },
                        );
                      }),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _currentFilter = null;
                          });
                          Navigator.pop(context);
                        },
                        child: const Text('CLEAR'),
                      ),
                      const SizedBox(width: 8),
                      FilledButton(
                        onPressed: () {
                          setState(() {
                            _currentFilter = tempFilter;
                          });
                          Navigator.pop(context);
                        },
                        child: const Text('APPLY'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _refreshTodos() {
    setState(() {
      _searchQuery = '';
      _currentFilter = null;
      _showCompletedOnly = false;
      _tabController.index = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context);
    final todos = _filterTodos(todoProvider.todoItems);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Todo List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshTodos,
            tooltip: 'Refresh',
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _showSearchDialog,
            tooltip: 'Search',
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: 'All Tasks'), Tab(text: 'Completed')],
          labelColor: theme.colorScheme.primary,
          indicatorColor: theme.colorScheme.onPrimary,
        ),
      ),
      body:
          todoProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : todos.isEmpty
              ? _buildEmptyState(context)
              : Padding(
                padding: const EdgeInsets.all(8),
                child:
                    MediaQuery.of(context).size.width > 600
                        ? GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 2.5,
                              ),
                          itemCount: todos.length,
                          itemBuilder:
                              (context, index) =>
                                  _buildTodoCard(context, todos[index], isDark),
                        )
                        : ListView.builder(
                          itemCount: todos.length,
                          itemBuilder:
                              (context, index) =>
                                  _buildTodoCard(context, todos[index], isDark),
                        ),
              ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEditTodoScreen()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Task'),
      ),
      floatingActionButtonLocation:
          MediaQuery.of(context).size.width > 600
              ? FloatingActionButtonLocation.endFloat
              : FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 80,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
          ),
          const SizedBox(height: 24),
          Text(
            'No tasks yet!',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            'Add some tasks to get started',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge!.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 36),
          FilledButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Add Your First Task'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddEditTodoScreen()),
              );
            },
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodoCard(BuildContext context, TodoItem todo, bool isDark) {
    final todoProvider = Provider.of<TodoProvider>(context);
    return Dismissible(
      key: Key(todo.id),
      background: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (_) async {
        await todoProvider.deleteTodo(todo.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Task deleted'),
            action: SnackBarAction(
              label: 'UNDO',
              onPressed: () async {
                await todoProvider.addTodo(todo);
              },
            ),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(color: todo.categoryColor, width: 5),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 12, right: 16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: todo.categoryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            todo.categoryEmoji,
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              todo.category,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Text(
                      todo.completed ? 'Completed' : 'Active',
                      style: TextStyle(
                        fontSize: 11,
                        color: todo.completed ? Colors.green : Colors.orange,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                leading: Container(
                  decoration: BoxDecoration(
                    color: todo.categoryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Checkbox(
                    value: todo.completed,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    onChanged: (_) => todoProvider.toggleTodoCompletion(todo),
                  ),
                ),
                title: Text(
                  todo.text,
                  style: TextStyle(
                    fontSize: 16,
                    decoration:
                        todo.completed ? TextDecoration.lineThrough : null,
                    color:
                        todo.completed
                            ? Colors.grey
                            : (isDark ? Colors.white : Colors.black87),
                    fontWeight:
                        todo.completed ? FontWeight.normal : FontWeight.w500,
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AddEditTodoScreen(todo: todo),
                          ),
                        );
                      },
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    Text(
                      'Swipe to delete',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
