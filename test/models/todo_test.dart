import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_todo_app/models/todo.dart';

void main() {
  group('Todo Model', () {
    final fixedDate = DateTime(2024, 1, 15, 10, 30);

    Todo createSample() => Todo(
          id: 'test-id-1',
          title: 'Buy groceries',
          description: 'Milk, eggs, bread',
          isCompleted: false,
          createdAt: fixedDate,
        );

    test('copyWith returns a new Todo with updated fields', () {
      final original = createSample();
      final updated = original.copyWith(
        title: 'Buy vegetables',
        isCompleted: true,
      );

      expect(updated.id, original.id);
      expect(updated.title, 'Buy vegetables');
      expect(updated.description, original.description);
      expect(updated.isCompleted, true);
      expect(updated.createdAt, original.createdAt);
    });

    test('copyWith with no arguments returns an equal Todo', () {
      final original = createSample();
      final copy = original.copyWith();

      expect(copy, equals(original));
      expect(identical(copy, original), isFalse);
    });

    test('toJson produces the correct map', () {
      final todo = createSample();
      final json = todo.toJson();

      expect(json['id'], 'test-id-11');
      expect(json['title'], 'Buy groceries');
      expect(json['description'], 'Milk, eggs, bread');
      expect(json['isCompleted'], false);
      expect(json['createdAt'], fixedDate.toIso8601String());
    });

    test('fromJson round-trips correctly', () {
      final original = createSample();
      final json = original.toJson();
      final restored = Todo.fromJson(json);

      expect(restored, equals(original));
    });

    test('equality works based on all fields', () {
      final a = createSample();
      final b = createSample();
      final c = a.copyWith(title: 'Different');

      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });
  });
}
