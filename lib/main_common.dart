import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_todo_app/models/todo.dart';
import 'package:flutter_todo_app/providers/providers.dart';
import 'package:flutter_todo_app/repositories/todo_repository.dart';
import 'package:flutter_todo_app/screens/todo_list_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'config/app_config.dart';

Future<void> bootstrap(Flavor flavor) async {
  WidgetsFlutterBinding.ensureInitialized();
  AppConfig.flavor = flavor;

  // 1. Init Hive
  await Hive.initFlutter();

  // 2. Register the adapter
  Hive.registerAdapter(TodoAdapter());

  // 3. Open the box
  final todoBox = await Hive.openBox<Todo>('todos');

  // 4. Run the app WITH the provider override + MaterialApp wrapper
  runApp(
    ProviderScope(
      overrides: [
        todoRepositoryProvider.overrideWithValue(HiveTodoRepository(todoBox)),
      ],
      child: MaterialApp(
  title: 'Todo App',
  debugShowCheckedModeBanner: false,
  theme: ThemeData(
    colorSchemeSeed: Colors.indigo,
    useMaterial3: true,
    brightness: Brightness.light,
  ),
  darkTheme: ThemeData(
    colorSchemeSeed: Colors.indigo,
    useMaterial3: true,
    brightness: Brightness.dark,
  ),
  home: const TodoListScreen(),
),
    ),
  );
}

