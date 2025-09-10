import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart';
import '../database/local_database.dart';
import '../core/service_locator.dart';

class TodoService {
  final LocalDatabase _db = serviceLocator<LocalDatabase>();

  // Get all todos
  Future<List<LocalTodo>> getAllTodos() async {
    return await _db.getAllTodos();
  }

  // Get completed todos
  Future<List<LocalTodo>> getCompletedTodos() async {
    return await _db.getCompletedTodos();
  }

  // Get pending todos
  Future<List<LocalTodo>> getPendingTodos() async {
    return await _db.getPendingTodos();
  }

  // Add a new todo
  Future<void> addTodo({
    required String title,
    String description = '',
    int priority = 1, // 1=low, 2=medium, 3=high
    DateTime? dueDate,
  }) async {
    final todo = LocalTodosCompanion(
      id: const Value<String>.absent(),
      title: Value(title),
      description: Value(description),
      priority: Value(priority),
      dueDate: dueDate != null ? Value(dueDate) : const Value.absent(),
      createdAt: Value(DateTime.now()),
      updatedAt: Value(DateTime.now()),
    );

    await _db.into(_db.localTodos).insert(todo);
  }

  // Update todo
  Future<void> updateTodo({
    required String id,
    String? title,
    String? description,
    int? priority,
    DateTime? dueDate,
    bool? isCompleted,
  }) async {
    final updates =
        LocalTodosCompanion(
          id: Value(id),
          updatedAt: Value(DateTime.now()),
        ).copyWith(
          title: title != null ? Value(title) : const Value.absent(),
          description: description != null
              ? Value(description)
              : const Value.absent(),
          priority: priority != null ? Value(priority) : const Value.absent(),
          dueDate: dueDate != null ? Value(dueDate) : const Value.absent(),
          isCompleted: isCompleted != null
              ? Value(isCompleted)
              : const Value.absent(),
          completedAt: isCompleted == true
              ? Value(DateTime.now())
              : isCompleted == false
              ? const Value.absent()
              : const Value.absent(),
        );

    await _db
        .into(_db.localTodos)
        .insert(updates, mode: InsertMode.insertOrReplace);
  }

  // Mark todo as completed
  Future<void> markTodoAsCompleted(String id) async {
    await _db.markTodoAsCompleted(id);
  }

  // Mark todo as pending
  Future<void> markTodoAsPending(String id) async {
    await _db.markTodoAsPending(id);
  }

  // Delete todo
  Future<void> deleteTodo(String id) async {
    await _db.markTodoForDeletion(id);
  }

  // Get todo by ID
  Future<LocalTodo?> getTodoById(String id) async {
    return await _db.getTodo(id);
  }
}
