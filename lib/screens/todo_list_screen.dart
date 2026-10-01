import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/todo.dart';
import '../providers/providers.dart';
import 'add_edit_todo_screen.dart';
import 'todo_detail_screen.dart';

class TodoListScreen extends ConsumerWidget {
  const TodoListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(filteredTodosProvider);
    final currentFilter = ref.watch(todoFilterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Todos'),
        elevation: 1,
      ),
      body: Column(
        children: [
          // ── Filter chips ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: TodoFilter.values.map((filter) {
                final label = filter.name[0].toUpperCase() + filter.name.substring(1);
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(label),
                    selected: currentFilter == filter,
                    onSelected: (_) =>
                        ref.read(todoFilterProvider.notifier).setFilter(filter),
                  ),
                );
              }).toList(),
            ),
          ),

          // ── Todo list ──
          Expanded(
            child: todos.isEmpty
                ? const Center(
                    child: Text(
                      'No todos yet.\nTap + to add one!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: todos.length,
                    itemBuilder: (context, index) {
                      final todo = todos[index];
                      return _TodoTile(todo: todo);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddEditTodoScreen()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _TodoTile extends ConsumerWidget {
  const _TodoTile({required this.todo});
  final Todo todo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dismissible(
      key: Key(todo.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) {
        ref.read(todoListProvider.notifier).deleteTodo(todo.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('"${todo.title}" deleted')),
        );
      },
      child: ListTile(
        leading: Checkbox(
          value: todo.isCompleted,
          onChanged: (_) =>
              ref.read(todoListProvider.notifier).toggleTodo(todo.id),
        ),
        title: Text(
          todo.title,
          style: TextStyle(
            decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle:
            todo.description.isNotEmpty ? Text(todo.description, maxLines: 1, overflow: TextOverflow.ellipsis) : null,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => TodoDetailScreen(todoId: todo.id)),
        ),
      ),
    );
  }
}
