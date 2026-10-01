import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_todo_app/models/todo.dart';
import 'package:flutter_todo_app/repositories/todo_repository.dart';
import 'package:flutter_todo_app/providers/providers.dart';

class MockTodoRepository extends Mock implements TodoRepository {}

class FakeTodo extends Fake implements Todo {}

void main() {
  late MockTodoRepository mockRepo;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(FakeTodo());
  });

  setUp(() {
    mockRepo = MockTodoRepository();
    when(() => mockRepo.getAll()).thenReturn([]);
    when(() => mockRepo.add(any())).thenAnswer((_) async {});
    when(() => mockRepo.update(any())).thenAnswer((_) async {});
    when(() => mockRepo.delete(any())).thenAnswer((_) async {});

    container = ProviderContainer(
      overrides: [
        todoRepositoryProvider.overrideWithValue(mockRepo),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('TodoNotifier', () {
    test('starts with an empty list when repository is empty', () {
      expect(container.read(todoListProvider), isEmpty);
    });

    test('addTodo appends a new todo to the state', () {
      container.read(todoListProvider.notifier).addTodo(
            title: 'Test Todo',
            description: 'Some desc',
          );

      final todos = container.read(todoListProvider);
      expect(todos, hasLength(1));
      expect(todos.first.title, 'Test Todo');
      expect(todos.first.description, 'Some desc');
      expect(todos.first.isCompleted, false);
      verify(() => mockRepo.add(any())).called(1);
    });

    test('toggleTodo flips isCompleted', () {
      container.read(todoListProvider.notifier).addTodo(title: 'Toggle me');
      final id = container.read(todoListProvider).first.id;

      expect(container.read(todoListProvider).first.isCompleted, false);

      container.read(todoListProvider.notifier).toggleTodo(id);
      expect(container.read(todoListProvider).first.isCompleted, true);

      container.read(todoListProvider.notifier).toggleTodo(id);
      expect(container.read(todoListProvider).first.isCompleted, false);
    });

    test('deleteTodo removes the todo from state', () {
      container.read(todoListProvider.notifier).addTodo(title: 'To delete');
      final id = container.read(todoListProvider).first.id;

      container.read(todoListProvider.notifier).deleteTodo(id);

      expect(container.read(todoListProvider), isEmpty);
      verify(() => mockRepo.delete(id)).called(1);
    });

    test('updateTodo replaces the matching todo', () {
      container.read(todoListProvider.notifier).addTodo(title: 'Original');
      final original = container.read(todoListProvider).first;
      final updated = original.copyWith(title: 'Updated');

      container.read(todoListProvider.notifier).updateTodo(updated);

      expect(container.read(todoListProvider).first.title, 'Updated');
      expect(container.read(todoListProvider), hasLength(1));
    });
  });
}
