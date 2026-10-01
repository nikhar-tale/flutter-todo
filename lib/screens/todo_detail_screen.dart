import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';
import 'add_edit_todo_screen.dart';

/// Read-only detail view for a single todo.
class TodoDetailScreen extends ConsumerWidget {
  final String todoId;
  const TodoDetailScreen({super.key, required this.todoId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todoListProvider);
    final todo = todos.where((t) => t.id == todoId).firstOrNull;

    // If the todo was deleted while this screen was open.
    if (todo == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Todo')),
        body: const Center(child: Text('Todo not found.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AddEditTodoScreen(todo: todo),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Delete',
            onPressed: () {
              ref.read(todoListProvider.notifier).deleteTodo(todo.id);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Status chip ──
            Chip(
              avatar: Icon(
                todo.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                color: todo.isCompleted ? Colors.green : Colors.orange,
              ),
              label: Text(todo.isCompleted ? 'Completed' : 'Active'),
            ),
            const SizedBox(height: 16),

            // ── Title ──
            Text(
              todo.title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),

            // ── Description ──
            if (todo.description.isNotEmpty)
              Text(
                todo.description,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            const Spacer(),

            // ── Created at ──
            Text(
              'Created: ${_formatDate(todo.createdAt)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}
