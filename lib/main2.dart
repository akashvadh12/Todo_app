// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// // import 'package:todo_app/firebase_options.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:todo_app/firebse/firebase_options.dart';

// void main() async {
//   // Ensure Flutter bindings are initialized before running the app
//   WidgetsFlutterBinding.ensureInitialized();
//   // Initialize Firebase with the provided options
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   // Run the TodoApp widget
//   runApp(const TodoApp());
// }

// // Main application widget
// class TodoApp extends StatelessWidget {
//   const TodoApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Todo App',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         // Light theme configuration
//         colorScheme: ColorScheme.fromSeed(
//           seedColor: Colors.deepPurple,
//           brightness: Brightness.light,
//         ),
//         useMaterial3: true,
//         fontFamily: 'Roboto',
//         cardTheme: CardTheme(
//           elevation: 3,
//           margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//         ),
//         inputDecorationTheme: InputDecorationTheme(
//           filled: true,
//           fillColor: Colors.grey.shade100,
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide.none,
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: const BorderSide(color: Colors.deepPurple),
//           ),
//         ),
//       ),
//       darkTheme: ThemeData(
//         // Dark theme configuration
//         colorScheme: ColorScheme.fromSeed(
//           seedColor: Colors.deepPurple,
//           brightness: Brightness.dark,
//         ),
//         useMaterial3: true,
//         cardTheme: CardTheme(
//           elevation: 3,
//           margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//         ),
//         inputDecorationTheme: InputDecorationTheme(
//           filled: true,
//           fillColor: Colors.grey.shade800,
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide.none,
//           ),
//         ),
//       ),
//       themeMode: ThemeMode.system,
//       home: const TodoListScreen(), // Set the home screen to TodoListScreen
//     );
//   }
// }

// // Model class representing a Todo item
// class TodoItem {
//   final String id; // Unique identifier for the todo item
//   final String text; // Text description of the todo item
//   final bool completed; // Completion status of the todo item
//   final String category; // Category of the todo item
//   final String categoryEmoji; // Emoji representing the category
//   final Color categoryColor; // Color associated with the category

//   TodoItem({
//     required this.id,
//     required this.text,
//     required this.completed,
//     this.category = 'Daily Routine',
//     this.categoryEmoji = '📅',
//     required this.categoryColor,
//   });

//   // Method to create a copy of the TodoItem with optional modifications
//   TodoItem copyWith({
//     String? id,
//     String? text,
//     bool? completed,
//     String? category,
//     String? categoryEmoji,
//     Color? categoryColor,
//   }) {
//     return TodoItem(
//       id: id ?? this.id,
//       text: text ?? this.text,
//       completed: completed ?? this.completed,
//       category: category ?? this.category,
//       categoryEmoji: categoryEmoji ?? this.categoryEmoji,
//       categoryColor: categoryColor ?? this.categoryColor,
//     );
//   }

//   // Convert TodoItem to JSON format for storage
//   Map<String, dynamic> toJson() {
//     return {
//       'text': text,
//       'completed': completed,
//       'category': category,
//       'categoryEmoji': categoryEmoji,
//       'categoryColor': categoryColor.value,
//     };
//   }

//   // Create a TodoItem from JSON data
//   factory TodoItem.fromJson(String id, Map<dynamic, dynamic> json) {
//     return TodoItem(
//       id: id,
//       text: json['text'] ?? '',
//       completed: json['completed'] ?? false,
//       category: json['category'] ?? 'Daily Routine',
//       categoryEmoji: json['categoryEmoji'] ?? '📅',
//       categoryColor: Color(json['categoryColor'] ?? Colors.purple.value),
//     );
//   }
// }

// // Main screen for displaying the list of todos
// class TodoListScreen extends StatefulWidget {
//   const TodoListScreen({Key? key}) : super(key: key);

//   @override
//   State<TodoListScreen> createState() => _TodoListScreenState();
// }

// class _TodoListScreenState extends State<TodoListScreen>
//     with SingleTickerProviderStateMixin {
//   final TextEditingController _textController = TextEditingController();
//   final DatabaseReference _database = FirebaseDatabase.instance.ref();
//   List<TodoItem> _todoItems = [];
//   List<TodoItem> _filteredTodos = [];
//   bool _isLoading = true;
//   String _searchQuery = '';
//   bool _showCompletedTasks = true;
//   String? _currentFilter;
//   late TabController _tabController;
//   String _selectedCategory = 'Daily Routine';
//   String _selectedCategoryEmoji = '📅';
//   Color _selectedCategoryColor = Colors.purple;
//   bool _isAddingNewTask = false;

//   // Categories with emojis, colors, and subcategories
//   final Map<String, Map<String, dynamic>> _categories = {
//     'Personal Productivity': {
//       'emoji': '✅',
//       'color': Colors.green,
//       'subcategories': [
//         '📚 Study',
//         '📖 Reading',
//         '🏋️‍♂️ Exercise / Workout',
//         '🧘‍♀️ Meditation',
//         '📓 Journaling',
//         '🧠 Learning a New Skill',
//       ],
//     },
//     'Errands & Shopping': {
//       'emoji': '🛍️',
//       'color': Colors.amber,
//       'subcategories': [
//         '🛒 Grocery Shopping',
//         '👗 Clothing',
//         '📱 Electronics',
//         '🧹 Household Items',
//         '💊 Pharmacy / Medicines',
//         '🎁 Gifts',
//       ],
//     },
//     'Entertainment & Leisure': {
//       'emoji': '🎬',
//       'color': Colors.deepOrange,
//       'subcategories': [
//         '🎥 Movies to Watch',
//         '📺 TV Shows / Web Series',
//         '🎧 Music / Albums to Listen',
//         '🎮 Games to Play',
//         '🎟️ Events / Concerts',
//       ],
//     },
//     'Home & Family': {
//       'emoji': '🏠',
//       'color': Colors.lightBlue,
//       'subcategories': [
//         '🧽 Cleaning / Organizing',
//         '🍽️ Cooking / Meal Prep',
//         '🧺 Laundry',
//         '🔧 Home Repairs',
//         '👨‍👩‍👧 Family Time',
//         '🐶 Pet Care',
//       ],
//     },
//     'Work & Career': {
//       'emoji': '💼',
//       'color': Colors.indigo,
//       'subcategories': [
//         '🖥️ Office Work',
//         '📆 Meetings / Appointments',
//         '📧 Emails / Follow-ups',
//         '📊 Projects / Deadlines',
//         '📝 Resume / Job Search',
//       ],
//     },
//     'Finance & Budgeting': {
//       'emoji': '💰',
//       'color': Colors.teal,
//       'subcategories': [
//         '💸 Pay Bills',
//         '🧾 Budget Planning',
//         '📉 Track Expenses',
//         '📈 Investments',
//       ],
//     },
//     'Travel & Outings': {
//       'emoji': '🚗',
//       'color': Colors.cyan,
//       'subcategories': [
//         '🧳 Trip Planning',
//         '📦 Packing Checklist',
//         '🗺️ Places to Visit',
//         '🎫 Book Tickets / Hotels',
//       ],
//     },
//     'Health & Wellness': {
//       'emoji': '❤️',
//       'color': Colors.pink,
//       'subcategories': [
//         '🩺 Doctor Appointments',
//         '💊 Medication',
//         '🥗 Diet Tracking',
//         '🧠 Therapy / Mental Health',
//       ],
//     },
//     'Daily Routine': {
//       'emoji': '📅',
//       'color': Colors.purple,
//       'subcategories': [
//         '🌅 Morning Routine',
//         '🌙 Night Routine',
//         '⏰ Reminders',
//       ],
//     },
//     'Goals & Habits': {
//       'emoji': '🎯',
//       'color': Colors.red,
//       'subcategories': [
//         '🥅 Short-Term Goals',
//         '🎯 Long-Term Goals',
//         '✅ Habit Tracker',
//       ],
//     },
//   };

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//     _loadTodos();
//   }

//   @override
//   void dispose() {
//     _textController.dispose();
//     _tabController.dispose();
//     super.dispose();
//   }

//   void _loadTodos() {
//     _database
//         .child('todos')
//         .onValue
//         .listen(
//           (event) {
//             if (event.snapshot.value != null) {
//               final data = event.snapshot.value as Map<dynamic, dynamic>;
//               setState(() {
//                 _todoItems =
//                     data.entries.map((entry) {
//                       return TodoItem.fromJson(entry.key, entry.value);
//                     }).toList();
//                 _applyFilters();
//                 _isLoading = false;
//               });
//             } else {
//               setState(() {
//                 _todoItems = [];
//                 _filteredTodos = [];
//                 _isLoading = false;
//               });
//             }
//           },
//           onError: (error) {
//             debugPrint('Error loading todos: $error');
//             setState(() {
//               _isLoading = false;
//             });
//           },
//         );
//   }

//   bool _isDuplicateTask(String text) {
//     return _todoItems.any(
//       (todo) => todo.text.toLowerCase().trim() == text.toLowerCase().trim(),
//     );
//   }

//   void _addTodo() async {
//     final String text = _textController.text.trim();
//     if (text.isEmpty) {
//       _showSnackBar('Please enter a task');
//       return;
//     }
//     if (_isDuplicateTask(text)) {
//       _showSnackBar('Task with this name already exists');
//       return;
//     }
//     try {
//       await _database.child('todos').push().set({
//         'text': text,
//         'completed': false,
//         'category': _selectedCategory,
//         'categoryEmoji': _selectedCategoryEmoji,
//         'categoryColor': _selectedCategoryColor.value,
//       });
//       _textController.clear();
//       // Don't reset category if we're in the middle of adding a task
//       if (!_isAddingNewTask) {
//         _resetCategory();
//       }
//     } catch (e) {
//       _showSnackBar('Failed to add todo: $e');
//     }
//   }

//   void _toggleTodo(TodoItem todo) async {
//     try {
//       await _database.child('todos/${todo.id}').update({
//         'completed': !todo.completed,
//       });
//     } catch (e) {
//       _showSnackBar('Failed to update todo: $e');
//     }
//   }

//   void _deleteTodo(TodoItem todo) async {
//     try {
//       await _database.child('todos/${todo.id}').remove();
//       _showSnackBar(
//         'Task deleted',
//         action: SnackBarAction(
//           label: 'UNDO',
//           onPressed: () async {
//             await _database.child('todos/${todo.id}').set(todo.toJson());
//           },
//         ),
//       );
//     } catch (e) {
//       _showSnackBar('Failed to delete todo: $e');
//     }
//   }

//   void _editTodo(TodoItem todo) {
//     _textController.text = todo.text;
//     _selectedCategory = todo.category;
//     _selectedCategoryEmoji = todo.categoryEmoji;
//     _selectedCategoryColor = todo.categoryColor;

//     showDialog(
//       context: context,
//       builder:
//           (context) => AlertDialog(
//             title: const Text('Edit Task'),
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 TextField(
//                   controller: _textController,
//                   decoration: const InputDecoration(
//                     labelText: 'Task',
//                     prefixIcon: Icon(Icons.edit),
//                   ),
//                   autofocus: true,
//                 ),
//                 const SizedBox(height: 16),
//                 InkWell(
//                   onTap: () {
//                     Navigator.pop(context);
//                     _showCategorySelectionDialog(isEditing: true, todo: todo);
//                   },
//                   child: Container(
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: _selectedCategoryColor.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(
//                         color: _selectedCategoryColor.withOpacity(0.3),
//                       ),
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Flexible(
//                           // to handle overflow
//                           child: Row(
//                             children: [
//                               Text(
//                                 _selectedCategoryEmoji,
//                                 style: const TextStyle(fontSize: 18),
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                               const SizedBox(width: 8),
//                               Flexible(
//                                 child: Text(
//                                   _selectedCategory,
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         Icon(
//                           Icons.arrow_drop_down,
//                           color: _selectedCategoryColor,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                   _resetCategory();
//                   _textController.clear();
//                 },
//                 child: const Text('CANCEL'),
//               ),
//               FilledButton(
//                 onPressed: () async {
//                   final newText = _textController.text.trim();
//                   if (newText.isEmpty) {
//                     _showSnackBar('Please enter a task');
//                     return;
//                   }
//                   if (_isDuplicateTask(newText) &&
//                       newText.toLowerCase() != todo.text.toLowerCase()) {
//                     _showSnackBar('Task with this name already exists');
//                     return;
//                   }
//                   try {
//                     await _database.child('todos/${todo.id}').update({
//                       'text': newText,
//                       'category': _selectedCategory,
//                       'categoryEmoji': _selectedCategoryEmoji,
//                       'categoryColor': _selectedCategoryColor.value,
//                     });
//                     if (mounted) {
//                       Navigator.pop(context);
//                       _resetCategory();
//                       _textController.clear();
//                     }
//                   } catch (e) {
//                     _showSnackBar('Failed to update todo: $e');
//                   }
//                 },
//                 child: const Text('SAVE'),
//               ),
//             ],
//           ),
//     );
//   }

//   void _resetCategory() {
//     _selectedCategory = 'Daily Routine';
//     _selectedCategoryEmoji = '📅';
//     _selectedCategoryColor = Colors.purple;
//   }

//   void _applyFilters() {
//     setState(() {
//       _filteredTodos =
//           _todoItems.where((todo) {
//             // Filter by search
//             bool matchesSearch =
//                 _searchQuery.isEmpty ||
//                 todo.text.toLowerCase().contains(_searchQuery.toLowerCase());

//             // Filter by completion status
//             bool matchesCompletionStatus =
//                 _showCompletedTasks || !todo.completed;

//             // Filter by category - improved logic
//             bool matchesCategory = true;
//             if (_currentFilter != null) {
//               // Check if filter matches main category
//               if (todo.category == _currentFilter) {
//                 matchesCategory = true;
//               }
//               // Check if filter matches a parent of the task's category
//               else if (_categories.containsKey(_currentFilter)) {
//                 List<String> subcategories =
//                     _categories[_currentFilter]!['subcategories']
//                         as List<String>;
//                 // Check each subcategory
//                 bool isSubcategory = false;
//                 for (var subcat in subcategories) {
//                   // Extract just the name without emoji
//                   final regex = RegExp(
//                     r'^(\p{Emoji_Presentation}|\p{Emoji}\uFE0F)?\s*(.*)',
//                     unicode: true,
//                   );
//                   final match = regex.firstMatch(subcat);
//                   String subcatName = subcat;
//                   if (match != null && match.groupCount >= 2) {
//                     subcatName = (match.group(2) ?? subcat).trim();
//                   }

//                   if (subcatName == todo.category) {
//                     isSubcategory = true;
//                     break;
//                   }
//                 }
//                 matchesCategory = isSubcategory;
//               } else {
//                 matchesCategory = false;
//               }
//             }

//             return matchesSearch && matchesCompletionStatus && matchesCategory;
//           }).toList();
//     });
//   }

//   void _showSnackBar(String message, {SnackBarAction? action}) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         action: action,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//         margin: const EdgeInsets.all(12),
//       ),
//     );
//   }

//   void _showAddDialog() {
//     _textController.clear();
//     if (!_isAddingNewTask) {
//       _resetCategory();
//     }

//     showDialog(
//       context: context,
//       builder:
//           (context) => AlertDialog(
//             title: Row(
//               children: [
//                 Icon(
//                   Icons.add_task,
//                   color: Theme.of(context).colorScheme.primary,
//                 ),
//                 const SizedBox(width: 8),
//                 const Expanded(
//                   child: Text(
//                     'Add a new task',
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//               ],
//             ),
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 TextField(
//                   controller: _textController,
//                   decoration: const InputDecoration(
//                     hintText: 'Enter task here',
//                     prefixIcon: Icon(Icons.edit),
//                   ),
//                   autofocus: true,
//                   onSubmitted: (_) {
//                     if (_textController.text.isNotEmpty) {
//                       _addTodo();
//                       Navigator.pop(context);
//                     }
//                   },
//                 ),
//                 const SizedBox(height: 16),
//                 InkWell(
//                   onTap: () {
//                     Navigator.pop(context);
//                     _showCategorySelectionDialog(isAddingNew: true);
//                   },
//                   child: Container(
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: _selectedCategoryColor.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(
//                         color: _selectedCategoryColor.withOpacity(0.3),
//                       ),
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Flexible(
//                           child: Row(
//                             children: [
//                               Text(
//                                 _selectedCategoryEmoji,
//                                 style: const TextStyle(fontSize: 18),
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                               const SizedBox(width: 8),
//                               Flexible(
//                                 child: Text(
//                                   _selectedCategory,
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         Icon(
//                           Icons.arrow_drop_down,
//                           color: _selectedCategoryColor,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                   _textController.clear();
//                   _isAddingNewTask = false;
//                 },
//                 child: const Text('CANCEL'),
//               ),
//               FilledButton(
//                 onPressed: () {
//                   if (_textController.text.isNotEmpty) {
//                     _addTodo();
//                     Navigator.pop(context);
//                     _isAddingNewTask = false;
//                   }
//                 },
//                 child: const Text('ADD'),
//               ),
//             ],
//           ),
//     );
//   }

//   void _showCategorySelectionDialog({
//     bool isAddingNew = false,
//     bool isEditing = false,
//     TodoItem? todo,
//   }) {
//     if (isAddingNew) {
//       _isAddingNewTask = true;
//     }

//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Row(
//             children: [
//               Icon(
//                 Icons.category,
//                 color: Theme.of(context).colorScheme.primary,
//               ),
//               const SizedBox(width: 8),
//               const Text('Select Category'),
//             ],
//           ),
//           content: SizedBox(
//             width: double.maxFinite,
//             height: 400,
//             child: ListView(
//               children:
//                   _categories.entries.map((entry) {
//                     String category = entry.key;
//                     String emoji = entry.value['emoji'];
//                     List<String> subcategories = List<String>.from(
//                       entry.value['subcategories'],
//                     );

//                     return ExpansionTile(
//                       leading: Container(
//                         width: 40,
//                         height: 40,
//                         decoration: BoxDecoration(
//                           color: entry.value['color'].withOpacity(0.2),
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: Center(
//                           child: Text(
//                             emoji,
//                             style: const TextStyle(fontSize: 20),
//                           ),
//                         ),
//                       ),
//                       title: Text(category, overflow: TextOverflow.ellipsis),
//                       children:
//                           subcategories.map((subcat) {
//                             final regex = RegExp(
//                               r'^(\p{Emoji_Presentation}|\p{Emoji}\uFE0F)?\s*(.*)',
//                               unicode: true,
//                             );
//                             final match = regex.firstMatch(subcat);
//                             String subcatEmoji = '';
//                             String subcatName = subcat;
//                             if (match != null && match.groupCount >= 2) {
//                               subcatEmoji = match.group(1) ?? '';
//                               subcatName = match.group(2) ?? subcat;
//                             }
//                             return ListTile(
//                               title: Text(
//                                 '$subcatEmoji $subcatName',
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                               onTap: () {
//                                 setState(() {
//                                   _selectedCategory = subcatName;
//                                   _selectedCategoryEmoji = emoji;
//                                   _selectedCategoryColor = entry.value['color'];
//                                 });
//                                 Navigator.of(context).pop();

//                                 if (isEditing && todo != null) {
//                                   _editTodo(todo);
//                                 } else {
//                                   _showAddDialog();
//                                 }
//                               },
//                             );
//                           }).toList(),
//                     );
//                   }).toList(),
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//                 if (isAddingNew) {
//                   _isAddingNewTask = false;
//                 }
//               },
//               child: const Text('CANCEL'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _showFilterDialog() {
//     String? tempCurrentFilter = _currentFilter;
//     bool tempShowCompletedTasks = _showCompletedTasks;

//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder:
//           (context) => StatefulBuilder(
//             builder:
//                 (context, setModalState) => Container(
//                   padding: const EdgeInsets.all(16),
//                   height: MediaQuery.of(context).size.height * 0.7,
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             'Filter Tasks',
//                             style: Theme.of(context).textTheme.titleLarge!
//                                 .copyWith(fontWeight: FontWeight.bold),
//                           ),
//                           IconButton(
//                             icon: const Icon(Icons.close),
//                             onPressed: () => Navigator.pop(context),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 16),
//                       Text(
//                         'Categories',
//                         style: Theme.of(context).textTheme.titleMedium,
//                       ),
//                       const SizedBox(height: 8),
//                       Expanded(
//                         child: SingleChildScrollView(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Wrap(
//                                 spacing: 8.0,
//                                 runSpacing: 8.0,
//                                 children: [
//                                   FilterChip(
//                                     label: const Text('All'),
//                                     selected: tempCurrentFilter == null,
//                                     onSelected: (selected) {
//                                       setModalState(() {
//                                         tempCurrentFilter = null;
//                                       });
//                                     },
//                                   ),
//                                   ..._categories.keys
//                                       .map(
//                                         (category) => FilterChip(
//                                           avatar: CircleAvatar(
//                                             backgroundColor:
//                                                 (_categories[category]!['color']
//                                                         as Color)
//                                                     .withOpacity(0.2),
//                                             child: Text(
//                                               _categories[category]!['emoji']
//                                                   as String,
//                                             ),
//                                           ),
//                                           label: Text(category),
//                                           selected:
//                                               tempCurrentFilter == category,
//                                           onSelected: (selected) {
//                                             setModalState(() {
//                                               tempCurrentFilter =
//                                                   selected ? category : null;
//                                             });
//                                           },
//                                         ),
//                                       )
//                                       .toList(),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       // SwitchListTile for show completed tasks can be enabled here if needed
//                       const SizedBox(height: 16),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           TextButton(
//                             onPressed: () {
//                               setModalState(() {
//                                 tempCurrentFilter = null;
//                                 tempShowCompletedTasks = true;
//                               });
//                             },
//                             child: const Text('RESET'),
//                           ),
//                           const SizedBox(width: 8),
//                           FilledButton(
//                             onPressed: () {
//                               setState(() {
//                                 _currentFilter = tempCurrentFilter;
//                                 _showCompletedTasks = tempShowCompletedTasks;
//                                 _applyFilters();
//                               });
//                               Navigator.pop(context);
//                             },
//                             child: const Text('APPLY'),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//           ),
//     );
//   }

//   // Refresh method that reloads tasks and resets filters
//   void _refreshTodos() {
//     setState(() {
//       _searchQuery = '';
//       _currentFilter = null;
//       _showCompletedTasks = true;
//     });
//     _loadTodos();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final isTablet = MediaQuery.of(context).size.width > 600;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('My Todo List'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             tooltip: 'Refresh',
//             onPressed: _refreshTodos,
//           ),
//           IconButton(
//             icon: const Icon(Icons.search),
//             onPressed: () {
//               showDialog(
//                 context: context,
//                 builder:
//                     (context) => AlertDialog(
//                       title: const Text('Search Tasks'),
//                       content: TextField(
//                         autofocus: true,
//                         decoration: const InputDecoration(
//                           hintText: 'Enter search term',
//                           prefixIcon: Icon(Icons.search),
//                         ),
//                         onChanged: (value) {
//                           setState(() {
//                             _searchQuery = value;
//                             _applyFilters();
//                           });
//                         },
//                       ),
//                       actions: [
//                         TextButton(
//                           onPressed: () {
//                             Navigator.pop(context);
//                             setState(() {
//                               _searchQuery = '';
//                               _applyFilters();
//                             });
//                           },
//                           child: const Text('CLEAR'),
//                         ),
//                         FilledButton(
//                           onPressed: () => Navigator.pop(context),
//                           child: const Text('DONE'),
//                         ),
//                       ],
//                     ),
//               );
//             },
//           ),
//           IconButton(
//             icon: const Icon(Icons.filter_list),
//             onPressed: _showFilterDialog,
//           ),
//         ],
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(50),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: TabBar(
//               controller: _tabController,
//               tabs: const [Tab(text: 'All Tasks'), Tab(text: 'Completed')],
//               labelColor: Theme.of(context).colorScheme.primary,
//               onTap: (index) {
//                 setState(() {
//                   _showCompletedTasks = true;
//                   if (index == 1) {
//                     _filteredTodos =
//                         _todoItems.where((todo) => todo.completed).toList();
//                   } else {
//                     _applyFilters();
//                   }
//                 });
//               },
//             ),
//           ),
//         ),
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : _todoItems.isEmpty
//               ? _buildEmptyState()
//               : _buildTasksList(isDark, isTablet),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: () {
//           _isAddingNewTask = true;
//           _showCategorySelectionDialog(isAddingNew: true);
//         },
//         icon: const Icon(Icons.add),
//         label: const Text('Add Task'),
//       ),
//       floatingActionButtonLocation: isTablet
//           ? FloatingActionButtonLocation.endFloat
//           : FloatingActionButtonLocation.centerFloat,
//     );
//   }

//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.check_circle_outline,
//             size: 80,
//             color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
//           ),
//           const SizedBox(height: 24),
//           Text(
//             'No tasks yet!',
//             style: Theme.of(
//               context,
//             ).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 12),
//           Text(
//             'Add some tasks to get started',
//             style: Theme.of(
//               context,
//             ).textTheme.bodyLarge!.copyWith(color: Colors.grey),
//           ),
//           const SizedBox(height: 36),
//           FilledButton.icon(
//             icon: const Icon(Icons.add),
//             label: const Text('Add Your First Task'),
//             onPressed: _showAddDialog,
//             style: FilledButton.styleFrom(
//               padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTasksList(bool isDark, bool isTablet) {
//     if (_filteredTodos.isEmpty) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.filter_list_off,
//               size: 64,
//               color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
//             ),
//             const SizedBox(height: 16),
//             Text(
//               'No matching tasks found',
//               style: Theme.of(context).textTheme.titleLarge,
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Try adjusting your filters',
//               style: Theme.of(
//                 context,
//               ).textTheme.bodyLarge!.copyWith(color: Colors.grey),
//             ),
//             const SizedBox(height: 24),
//             FilledButton.icon(
//               icon: const Icon(Icons.refresh),
//               label: const Text('Reset Filters'),
//               onPressed: () {
//                 setState(() {
//                   _searchQuery = '';
//                   _currentFilter = null;
//                   _showCompletedTasks = true;
//                   _applyFilters();
//                 });
//               },
//             ),
//           ],
//         ),
//       );
//     }
//     return Padding(
//       padding: const EdgeInsets.all(8),
//       child: isTablet
//           ? GridView.builder(
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 childAspectRatio: 2.5,
//               ),
//               itemCount: _filteredTodos.length,
//               itemBuilder: (context, index) =>
//                   _buildTodoCard(_filteredTodos[index], isDark),
//             )
//           : ListView.builder(
//               itemCount: _filteredTodos.length,
//               itemBuilder: (context, index) =>
//                   _buildTodoCard(_filteredTodos[index], isDark),
//             ),
//     );
//   }

//   Widget _buildTodoCard(TodoItem todo, bool isDark) {
//     return Dismissible(
//       key: Key(todo.id),
//       background: Container(
//         margin: const EdgeInsets.symmetric(vertical: 8),
//         decoration: BoxDecoration(
//           color: Colors.red,
//           borderRadius: BorderRadius.circular(16),
//         ),
//         alignment: Alignment.centerRight,
//         padding: const EdgeInsets.symmetric(horizontal: 20),
//         child: const Icon(Icons.delete, color: Colors.white),
//       ),
//       direction: DismissDirection.endToStart,
//       onDismissed: (_) => _deleteTodo(todo),
//       child: Card(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         child: Container(
//           decoration: BoxDecoration(
//             border: Border(
//               left: BorderSide(color: todo.categoryColor, width: 5),
//             ),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(left: 16, top: 12, right: 16),
//                 child: Row(
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 8,
//                         vertical: 4,
//                       ),
//                       decoration: BoxDecoration(
//                         color: todo.categoryColor.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Text(
//                             todo.categoryEmoji,
//                             style: const TextStyle(fontSize: 14),
//                           ),
//                           const SizedBox(width: 4),
//                           Flexible(
//                             child: Text(
//                               todo.category,
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.w500,
//                                 color: isDark ? Colors.white : Colors.black87,
//                               ),
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const Spacer(),
//                     Text(
//                       todo.completed ? 'Completed' : 'Active',
//                       style: TextStyle(
//                         fontSize: 11,
//                         color: todo.completed ? Colors.green : Colors.orange,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               ListTile(
//                 contentPadding: const EdgeInsets.symmetric(
//                   horizontal: 16,
//                   vertical: 4,
//                 ),
//                 leading: Container(
//                   decoration: BoxDecoration(
//                     color: todo.categoryColor.withOpacity(0.1),
//                     shape: BoxShape.circle,
//                   ),
//                   child: Checkbox(
//                     value: todo.completed,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(4),
//                     ),
//                     onChanged: (_) => _toggleTodo(todo),
//                   ),
//                 ),
//                 title: Text(
//                   todo.text,
//                   style: TextStyle(
//                     fontSize: 16,
//                     decoration:
//                         todo.completed ? TextDecoration.lineThrough : null,
//                     color: todo.completed
//                         ? Colors.grey
//                         : (isDark ? Colors.white : Colors.black87),
//                     fontWeight:
//                         todo.completed ? FontWeight.normal : FontWeight.w500,
//                   ),
//                 ),
//                 trailing: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     IconButton(
//                       icon: const Icon(Icons.edit, size: 20),
//                       onPressed: () => _editTodo(todo),
//                       color: Theme.of(context).colorScheme.primary,
//                     ),
//                     Text(
//                       'Swipe to delete',
//                       style: TextStyle(
//                         fontSize: 10,
//                         color: Colors.grey.withOpacity(0.7),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

