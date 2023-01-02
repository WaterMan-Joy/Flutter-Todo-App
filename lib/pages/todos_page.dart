// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:todo_sample1/providers/providers.dart';

import '../models/todo_model.dart';
import '../providers/active_todo_count.dart';

class TodosPage extends StatefulWidget {
  const TodosPage({super.key});

  @override
  State<TodosPage> createState() => _TodosPageState();
}

class _TodosPageState extends State<TodosPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Column(
              children: [
                TodoHeader(),
                CreateTodo(),
                SizedBox(
                  height: 20,
                ),
                SearchAndFilterTodo(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// TodoHeader
class TodoHeader extends StatelessWidget {
  const TodoHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '메모 앱',
          style: TextStyle(
            fontSize: 40,
          ),
        ),
        Text(
          '${context.watch<ActiveTodoCount>().state.activeTodoCount} 개',
          style: TextStyle(
            fontSize: 20,
            color: Colors.redAccent,
          ),
        ),
      ],
    );
  }
}

// CreateTodo
class CreateTodo extends StatefulWidget {
  const CreateTodo({super.key});

  @override
  State<CreateTodo> createState() => _CreateTodoState();
}

class _CreateTodoState extends State<CreateTodo> {
  final newTodoController = TextEditingController();

  @override
  void dispose() {
    // CreateTodo() 가 dispose() 될 때 newTodoController 도 함께 dispose() 된다
    newTodoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: newTodoController,
      decoration: InputDecoration(labelText: 'What to do?'),
      onSubmitted: (String? todoDesc) {
        if (todoDesc != null && todoDesc.trim().isNotEmpty) {
          print('새로 추가된 메모: ${todoDesc}');
          context.read<TodoList>().addTodo(todoDesc);
          newTodoController.clear();
        } else {
          print('메모 추가 실패');
        }
      },
    );
  }
}

// SearchAndFilter
class SearchAndFilterTodo extends StatelessWidget {
  const SearchAndFilterTodo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            labelText: '메모 검색',
            border: InputBorder.none,
            filled: true,
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (String? newSearchTerm) {
            if (newSearchTerm != null) {
              context.read<TodoSearch>().setSearchTerm(newSearchTerm);
            }
          },
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            filterButton(context, Filter.all),
            filterButton(context, Filter.active),
            filterButton(context, Filter.completed),
          ],
        ),
        ShowTodos(),
      ],
    );
  }

  Widget filterButton(BuildContext context, Filter filter) {
    return TextButton(
      onPressed: () {
        context.read<TodoFilter>().ChangeFilter(filter);
      },
      child: Text(
        filter == Filter.all
            ? 'All'
            : filter == Filter.active
                ? 'Active'
                : 'Completed',
        style: TextStyle(
          fontSize: 20,
          color: textColor(context, filter),
        ),
      ),
    );
  }

  Color textColor(BuildContext context, Filter filter) {
    final currentFilter = context.watch<TodoFilter>().state.filter;
    return currentFilter == filter ? Colors.blue : Colors.grey;
  }
}

// ShowTodos
class ShowTodos extends StatelessWidget {
  const ShowTodos({super.key});

  Widget showBackGround(int direction) {
    return Container(
      margin: EdgeInsets.all(4),
      padding: EdgeInsets.symmetric(horizontal: 10),
      color: Colors.red,
      alignment: direction == 0 ? Alignment.centerLeft : Alignment.centerRight,
      child: Icon(
        Icons.delete,
        size: 30,
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // todos 는 값이 변해야 하기 때문에 watch() 를 사용한다
    final todos = context.watch<FilteredTodos>().state.filteredTodos;
    return ListView.separated(
      primary: false,
      shrinkWrap: true,
      itemBuilder: ((context, index) => Dismissible(
            onDismissed: ((DismissDirection _) =>
                context.read<TodoList>().removeTodo(todos[index])),
            background: showBackGround(0),
            secondaryBackground: showBackGround(1),
            key: ValueKey(todos[index].id),
            child: TodoItem(
              todo: todos[index],
            ),
            confirmDismiss: (DismissDirection _) {
              return showDialog(
                context: context,
                // barrerDismissible 은 바깥 화면을 눌러도 취소가 되지 않는다
                barrierDismissible: false,
                builder: (context) {
                  return AlertDialog(
                    title: Text('삭제하기'),
                    content: Text('정말 삭제하시겠습니까?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text('취소'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: Text('확인'),
                      ),
                    ],
                  );
                },
              );
            },
          )),
      separatorBuilder: (context, index) => Divider(
        color: Colors.grey,
      ),
      itemCount: todos.length,
    );
  }
}

// TodoItem
class TodoItem extends StatefulWidget {
  final Todo todo;
  const TodoItem({
    Key? key,
    required this.todo,
  }) : super(key: key);

  @override
  State<TodoItem> createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoItem> {
  late final TextEditingController textController;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        showDialog(
            context: (context),
            builder: (context) {
              bool _error = false;
              textController.text = widget.todo.desc;

              return StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                return AlertDialog(
                  title: Text('수정'),
                  content: TextField(
                    controller: textController,
                    autofocus: true,
                    decoration: InputDecoration(
                        errorText: _error ? '수정 할 수 없습니다' : null),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('취소'),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _error = textController.text.isEmpty ? true : false;
                          if (!_error) {
                            context
                                .read<TodoList>()
                                .editTodo(widget.todo.id, textController.text);
                            Navigator.pop(context);
                          }
                        });
                      },
                      child: Text('확인'),
                    ),
                  ],
                );
              });
            });
      },
      leading: Checkbox(
        onChanged: (bool? checked) {
          context.read<TodoList>().toggleTodo(widget.todo.id);
        },
        value: widget.todo.completed,
      ),
      title: Text(widget.todo.desc),
    );
  }
}
