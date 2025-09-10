import 'package:flutter/material.dart';
import 'package:telemed/database/local_database.dart';
import '../services/todo_service.dart';
import '../core/service_locator.dart';

class TodosScreen extends StatefulWidget {
  const TodosScreen({Key? key}) : super(key: key);

  @override
  _TodosScreenState createState() => _TodosScreenState();
}

class _TodosScreenState extends State<TodosScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TodoService _todoService = getService<TodoService>();
  List<LocalTodo> _todos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final todos = await _todoService.getAllTodos();
      setState(() {
        _todos = todos;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error loading todos: $e')));
    }
  }

  Future<void> _addTodo() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter a title')));
      return;
    }

    try {
      await _todoService.addTodo(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
      );
      _titleController.clear();
      _descriptionController.clear();
      await _loadTodos();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Todo added successfully')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error adding todo: $e')));
    }
  }

  Future<void> _toggleTodoCompletion(LocalTodo todo) async {
    try {
      if (todo.isCompleted) {
        await _todoService.markTodoAsPending(todo.id);
      } else {
        await _todoService.markTodoAsCompleted(todo.id);
      }
      await _loadTodos();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error updating todo: $e')));
    }
  }

  Future<void> _deleteTodo(String id) async {
    try {
      await _todoService.deleteTodo(id);
      await _loadTodos();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Todo deleted')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error deleting todo: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Tracker'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        children: [
          // Add todo form
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Todo Title',
                    hintText: 'e.g., Take medication, Exercise',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description (Optional)',
                    hintText: 'Additional details',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _addTodo,
                  child: const Text('Add Todo'),
                ),
              ],
            ),
          ),
          const Divider(),
          // Todo list
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _todos.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No todos yet',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Add a todo to get started',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _todos.length,
                    itemBuilder: (context, index) {
                      final todo = _todos[index];
                      return _buildTodoItem(todo);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodoItem(LocalTodo todo) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Checkbox(
          value: todo.isCompleted,
          onChanged: (_) => _toggleTodoCompletion(todo),
        ),
        title: Text(
          todo.title,
          style: TextStyle(
            decoration: todo.isCompleted
                ? TextDecoration.lineThrough
                : TextDecoration.none,
            color: todo.isCompleted ? Colors.grey : Colors.black,
          ),
        ),
        subtitle: (todo.description?.isNotEmpty ?? false)
            ? Text(
                todo.description!,
                style: TextStyle(
                  decoration: todo.isCompleted
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                  color: todo.isCompleted ? Colors.grey : Colors.black54,
                ),
              )
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!todo.isCompleted)
              Icon(
                todo.priority == 3
                    ? Icons.priority_high
                    : todo.priority == 2
                    ? Icons.arrow_upward
                    : Icons.low_priority,
                color: todo.priority == 3
                    ? Colors.red
                    : todo.priority == 2
                    ? Colors.orange
                    : Colors.green,
                size: 20,
              ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteTodo(todo.id),
            ),
          ],
        ),
        onTap: () => _toggleTodoCompletion(todo),
      ),
    );
  }
}
