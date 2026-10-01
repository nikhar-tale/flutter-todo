import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/todo.dart';
import '../repositories/todo_repository.dart';
import 'todo_notifier.dart';

/// The filter applied to the todo list.
enum TodoFilter { all, active, completed }

/// Notifier for the current filter selection.
class TodoFilterNotifier extends Notifier<TodoFilter> {
  @override
  TodoFilter build() => TodoFilter.all;

  void setFilter(TodoFilter filter) {
    state = filter;
  }
}

/// Provider for the [TodoRepository].
/// Must be overridden in `main()` after Hive is initialised.
final todoRepositoryProvider = Provider<TodoRepository>((ref) {
  throw UnimplementedError('todoRepositoryProvider must be overridden');
});

/// Provider for the [TodoNotifier].
final todoListProvider =
    NotifierProvider<TodoNotifier, List<Todo>>(TodoNotifier.new);

/// Current filter selection.
final todoFilterProvider =
    NotifierProvider<TodoFilterNotifier, TodoFilter>(TodoFilterNotifier.new);

/// Derived provider that applies the current filter.
final filteredTodosProvider = Provider<List<Todo>>((ref) {
  final todos = ref.watch(todoListProvider);
  final filter = ref.watch(todoFilterProvider);

  switch (filter) {
    case TodoFilter.all:
      return todos;
    case TodoFilter.active:
      return todos.where((t) => !t.isCompleted).toList();
    case TodoFilter.completed:
      return todos.where((t) => t.isCompleted).toList();
  }
});
