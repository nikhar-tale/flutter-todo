import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_todo_app/models/todo.dart';
import 'package:flutter_todo_app/providers/providers.dart';
import 'package:flutter_todo_app/repositories/todo_repository.dart';
import 'package:flutter_todo_app/screens/add_edit_todo_screen.dart';

class MockTodoRepository extends Mock implements TodoRepository {}

class FakeTodo extends Fake implements Todo {}

Widget createTestApp(TodoRepository repo, {Todo? todo}) {
  return ProviderScope(
    overrides: [
      todoRepositoryProvider.overrideWithValue(repo),
    ],
    child: MaterialApp(home: AddEditTodoScreen(todo: todo)),
  );
}

void main() {
  late MockTodoRepository mockRepo;

  setUpAll(() {
    registerFallbackValue(FakeTodo());
  });

  setUp(() {
    mockRepo = MockTodoRepository();
    when(() => mockRepo.getAll()).thenReturn([]);
    when(() => mockRepo.add(any())).thenAnswer((_) async {});
    when(() => mockRepo.update(any())).thenAnswer((_) async {});
    when(() => mockRepo.delete(any())).thenAnswer((_) async {});
  });

  group('AddEditTodoScreen', () {
    testWidgets('validates empty title field', (tester) async {
      await tester.pumpWidget(createTestApp(mockRepo));

      // Try to submit with empty title
      await tester.tap(find.byKey(const Key('save_button')));
      await tester.pumpAndSettle();

      expect(find.text('Title cannot be empty'), findsOneWidget);
    });
  });
}
