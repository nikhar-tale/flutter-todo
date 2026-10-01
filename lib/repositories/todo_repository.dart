import 'package:hive/hive.dart';
import '../models/todo.dart';

/// Thin abstraction over Hive for Todo CRUD operations.
/// Using an abstract class makes unit-testing the notifier trivial.
abstract class TodoRepository {
  List<Todo> getAll();
  Future<void> add(Todo todo);
  Future<void> update(Todo todo);
  Future<void> delete(String id);
}

class HiveTodoRepository implements TodoRepository {
  final Box<Todo> _box;

  HiveTodoRepository(this._box);

  @override
  List<Todo> getAll() => _box.values.toList();

  @override
  Future<void> add(Todo todo) => _box.put(todo.id, todo);

  @override
  Future<void> update(Todo todo) => _box.put(todo.id, todo);

  @override
  Future<void> delete(String id) => _box.delete(id);
}
