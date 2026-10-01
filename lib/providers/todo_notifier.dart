import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/todo.dart';
import '../repositories/todo_repository.dart';
import 'providers.dart';

/// Manages the list of todos via a [TodoRepository].
class TodoNotifier extends Notifier<List<Todo>> {
  static const _uuid = Uuid();

  @override
  List<Todo> build() {
    final repository = ref.watch(todoRepositoryProvider);
    return repository.getAll();
  }

  TodoRepository get _repository => ref.read(todoRepositoryProvider);

  void addTodo({required String title, String description = ''}) {
    final todo = Todo(
      id: _uuid.v4(),
      title: title,
      description: description,
    );
    _repository.add(todo);
    state = [...state, todo];
  }

  void updateTodo(Todo updated) {
    _repository.update(updated);
    state = [
      for (final todo in state)
        if (todo.id == updated.id) updated else todo,
    ];
  }

  void deleteTodo(String id) {
    _repository.delete(id);
    state = state.where((t) => t.id != id).toList();
  }

  void toggleTodo(String id) {
    final todo = state.firstWhere((t) => t.id == id);
    final toggled = todo.copyWith(isCompleted: !todo.isCompleted);
    updateTodo(toggled);
  }
}
