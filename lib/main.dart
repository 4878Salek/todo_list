import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: TodoPage(),
  ));
}

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}
  
class _TodoPageState extends State<TodoPage> {
  final _controller = TextEditingController();
  TodoPriority priority = TodoPriority.Normal;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addTodo();
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text('My Todos'),
      ),
      body: MyTodo.todos.isEmpty
          ? const Center(
              child: Text('Nothing To Do!'),
            )
          : ListView.builder(
              itemCount: MyTodo.todos.length,
              itemBuilder: (context, index) {
                final todo = MyTodo.todos[index];
                return TodoItem(
                    todo: todo,
                    onChanged: (value) {
                      setState(() {
                        MyTodo.todos[index].completed = value;
                      });
                    });
              },
            ),
    );
  }

  void addTodo() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setBuilderState) => Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _controller,
                decoration:
                    const InputDecoration(hintText: 'What To Do Samim Salek'),
              ),
              const Padding(
                padding: EdgeInsets.all(8),
                child: Text('Select Priority'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Radio<TodoPriority>(
                      value: TodoPriority.Low,
                      groupValue: priority,
                      onChanged: (value) {
                        setBuilderState(() {
                          priority = value!;
                        });
                      }),
                  Text(TodoPriority.Low.name),
                  Radio<TodoPriority>(
                      value: TodoPriority.Normal,
                      groupValue: priority,
                      onChanged: (value) {
                        setBuilderState(() {
                          priority = value!;
                        });
                      }),
                  Text(TodoPriority.Normal.name),
                  Radio<TodoPriority>(
                      value: TodoPriority.High,
                      groupValue: priority,
                      onChanged: (value) {
                        setBuilderState(() {
                          priority = value!;
                        });
                      }),
                  Text(TodoPriority.High.name),
                ],
              ),
              ElevatedButton(onPressed: _save, child: Text('SAVE')),
            ],
          ),
        ),
      ),
    );
  }

  void _save() {
    if (_controller.text.isEmpty) {
      showMsg(context, 'Input field must not be empty');
      return;
    }
    final todo = MyTodo(
        id: DateTime.now().millisecondsSinceEpoch,
        priority: priority,
        name: _controller.text);
    MyTodo.todos.add(todo);
    _controller.clear();
    setState(() {});
    Navigator.pop(context);
  }

  void showMsg(BuildContext context, String s) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Caution!'),
        content: Text(s),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('CLOSE'))
        ],
      ),
    );
  }
}

class TodoItem extends StatelessWidget {
  final MyTodo todo;
  final Function(bool) onChanged;
  const TodoItem({super.key, required this.todo, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
        title: Text(todo.name),
        subtitle: Text('Priority ${todo.priority.name}'),
        value: todo.completed,
        onChanged: (value) {
          onChanged(value!);
        });
  }
}

class MyTodo {
  int id;
  String name;
  bool completed;
  TodoPriority priority;
  MyTodo(
      {required this.priority,
      required this.id,
      this.completed = false,
      required this.name});
  static List<MyTodo> todos = [];
}
enum TodoPriority { Low, Normal, High }
