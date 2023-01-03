import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_sample1/pages/todos_page.dart';
import 'package:todo_sample1/providers/providers.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TodoFilter>(create: (context) => TodoFilter()),
        ChangeNotifierProvider<TodoSearch>(create: (context) => TodoSearch()),
        ChangeNotifierProvider<TodoList>(create: (context) => TodoList()),
        ProxyProvider<TodoList, ActiveTodoCount>(
          update: (
            BuildContext context,
            TodoList todolist,
            ActiveTodoCount? _,
          ) =>
              ActiveTodoCount(todoList: todolist),
        ),
        ProxyProvider3<TodoFilter, TodoSearch, TodoList, FilteredTodos>(
          update: (
            BuildContext cotext,
            TodoFilter todoFilter,
            TodoSearch todoSearch,
            TodoList todoList,
            FilteredTodos? _,
          ) =>
              FilteredTodos(
                  todoFilter: todoFilter,
                  todoSearch: todoSearch,
                  todoList: todoList),
        ),
      ],
      child: MaterialApp(
        title: 'Todo-App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
        ),
        home: TodosPage(),
      ),
    );
  }
}
