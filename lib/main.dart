// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:hive_flutter/hive_flutter.dart';

// import 'models/todo.dart';
// import 'providers/providers.dart';
// import 'repositories/todo_repository.dart';
// import 'screens/todo_list_screen.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   // ── Hive setup ──
//   await Hive.initFlutter();
//   Hive.registerAdapter(TodoAdapter());
//   final todoBox = await Hive.openBox<Todo>('todos');

//   runApp(
//     ProviderScope(
//       overrides: [
//         todoRepositoryProvider.overrideWithValue(HiveTodoRepository(todoBox)),
//       ],
//       child: const TodoApp(),
//     ),
//   );
// }

// class TodoApp extends StatelessWidget {
//   const TodoApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Todo App',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         colorSchemeSeed: Colors.indigo,
//         useMaterial3: true,
//         brightness: Brightness.light,
//       ),
//       darkTheme: ThemeData(
//         colorSchemeSeed: Colors.indigo,
//         useMaterial3: true,
//         brightness: Brightness.dark,
//       ),
//       home: const TodoListScreen(),
//     );
//   }
// }
