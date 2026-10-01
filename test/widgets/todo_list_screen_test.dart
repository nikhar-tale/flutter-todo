import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_todo_app/models/todo.dart';
import 'package:flutter_todo_app/providers/providers.dart';
import 'package:flutter_todo_app/repositories/todo_repository.dart';
import 'package:flutter_todo_app/screens/todo_list_screen.dart';

class MockTodoRepository extends Mock implements TodoRepository {}

class FakeTodo extends Fake implements Todo {}

/// Pumps [TodoListScreen] wrapped in the necessary providers.
Widget createTestApp(TodoRepository repo) {
  return ProviderScope(
    overrides: [
      todoRepositoryProvider.overrideWithValue(repo),
    ],
    child: const MaterialApp(home: TodoListScreen()),
  );
}

void main() {
  late MockTodoRepository mockRepo;

  setUpAll(() {
    registerFallbackValue(FakeTodo());
  });

  setUp(() {
    mockRepo = MockTodoRepository();
    when(() => mockRepo.add(any())).thenAnswer((_) async {});
    when(() => mockRepo.update(any())).thenAnswer((_) async {});
    when(() => mockRepo.delete(any())).thenAnswer((_) async {});
  });

  group('TodoListScreen', () {
    testWidgets('shows empty state when no todos exist', (tester) async {
      when(() => mockRepo.getAll()).thenReturn([]);

      await tester.pumpWidget(createTestApp(mockRepo));

      expect(find.text('No todos yet.\nTap + to add one!'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('renders todo tiles when todos exist', (tester) async {
      when(() => mockRepo.getAll()).thenReturn([
        Todo(
          id: '1',
          title: 'First todo',
          description: 'Description 1',
          createdAt: DateTime(2024),
        ),
        Todo(
          id: '2',
          title: 'Second todo',
          isCompleted: true,
          createdAt: DateTime(2024),
        ),
      ]);

      await tester.pumpWidget(createTestApp(mockRepo));

      expect(find.text('First todo'), findsOneWidget);
      expect(find.text('Second todo'), findsOneWidget);
      // Completed todo should have a checked checkbox
      final checkboxes = tester.widgetList<Checkbox>(find.byType(Checkbox)).toList();
      expect(checkboxes[0].value, false);
      expect(checkboxes[1].value, true);
    });
  });
}
