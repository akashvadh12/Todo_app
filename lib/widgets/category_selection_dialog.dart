// import 'package:flutter/material.dart';
// import 'package:flutter/material.dart';
// import 'package:todo_app/model_class/todo_item.dart';
// import 'package:todo_app/widgets/category_selection_dialog.dart';

// class CategorySelectionDialog extends StatelessWidget {
//   final Map<String, Map<String, dynamic>> categories;
//   final Function(String category, String emoji, Color color) onSelected;

//   const CategorySelectionDialog({
//     Key? key,
//     required this.categories,
//     required this.onSelected,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Row(
//         children: [
//           Icon(Icons.category, color: Theme.of(context).colorScheme.primary),
//           const SizedBox(width: 8),
//           const Text('Select Category'),
//         ],
//       ),
//       content: SizedBox(
//         width: double.maxFinite,
//         height: 400,
//         child: ListView(
//           children:
//               categories.entries.map((entry) {
//                 String category = entry.key;
//                 String emoji = entry.value['emoji'];
//                 Color color = entry.value['color'];
//                 List<String> subcategories = entry.value['subcategories'];

//                 return ExpansionTile(
//                   leading: Container(
//                     width: 40,
//                     height: 40,
//                     decoration: BoxDecoration(
//                       color: color.withOpacity(0.2),
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Center(
//                       child: Text(emoji, style: const TextStyle(fontSize: 20)),
//                     ),
//                   ),
//                   title: Text(category),
//                   children:
//                       subcategories.map((subcat) {
//                         return ListTile(
//                           title: Text(subcat),
//                           onTap: () {
//                             onSelected(subcat, emoji, color);
//                             Navigator.of(context).pop();
//                           },
//                         );
//                       }).toList(),
//                 );
//               }).toList(),
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.pop(context),
//           child: const Text('CANCEL'),
//         ),
//       ],
//     );
//   }
// }
