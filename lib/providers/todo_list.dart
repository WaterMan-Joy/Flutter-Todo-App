// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ffi';

import 'package:flutter/cupertino.dart';

import '../models/todo_model.dart';

class TodoListState {
  // todos라는 Todo타입의 배열을 만든다
  final List<Todo> todos;
  TodoListState({
    required this.todos,
  });

  // 싱글톤으로 만들었다
  factory TodoListState.initial() {
    return TodoListState(todos: [
      Todo(id: '1', desc: 'AAAAA'),
      Todo(id: '2', desc: 'BBBBB'),
      Todo(id: '3', desc: 'CCCCC'),
    ]);
  }

  // 배열로 겟터로 외부에서 불러올 수 있도록 할 수 있다
  List<Object> get props => [todos];

  bool get stringify => true;

  TodoListState copywith({List<Todo>? todos}) {
    return TodoListState(todos: todos ?? this.todos);
  }
}

class TodoList with ChangeNotifier {
  TodoListState _state = TodoListState.initial();
  // getter로 외부에서 호출할 수 있다
  TodoListState get state => _state;

  // 더하는 Todo
  void addTodo(String todoDesc) {
    // 반드시 필요한 desc 을 newTodo 변수에 담는다
    final newTodo = Todo(desc: todoDesc);
    // 초기화된 _state의 todos와, 방금 만들어진 newTodo 를 합친 새로운 newTodos
    final newTodos = [..._state.todos, newTodo];
    // newTodo를 더한 newTodos를 이제 Todo class 에 저장하자
    _state = _state.copywith(todos: newTodos);
    // 변화를 감지해서 반영해주는 함수
    notifyListeners();
  }

  // 수정하는 Todo
  void editTodo(String id, String todoDesc) {
    // todos안에 있는 배열을 map으로 분리해서 todo.id가 editTodo안에 있는 id인자와 같은지 확인한다
    final newTodos = _state.todos.map((Todo todo) {
      if (todo.id == id) {
        return Todo(id: id, desc: todoDesc, completed: todo.completed);
      }
      return todo;
      // toList() 함수는 리스트로 만들어 준다
    }).toList();
    // newTodos에 있는 id값을 확인하여 todo를 리턴해한 것을 _state에 저장한다
    _state = _state.copywith(todos: newTodos);
    notifyListeners();
  }

  // 토글형 체크 Todo
  void toggleTodo(String id) {
    final newTodos = _state.todos.map((Todo todo) {
      if (todo.id == id) {
        return Todo(id: id, desc: todo.desc, completed: !todo.completed);
      }
      return todo;
    }).toList();
    _state = _state.copywith(todos: newTodos);
    // 변화를 감지해 반영해주는 함수
    notifyListeners();
  }

  // 삭제하는 Todo
  void removeTodo(Todo todo) {
    final newTodos = _state.todos.where((Todo t) => t.id != todo.id).toList();
    _state = _state.copywith(todos: newTodos);
    notifyListeners();
  }
}
