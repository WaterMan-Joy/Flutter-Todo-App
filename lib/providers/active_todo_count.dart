// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:todo_sample1/providers/todo_list.dart';

import '../models/todo_model.dart';

class ActiveTodoCountState {
  final int activeTodoCount;
  ActiveTodoCountState({
    required this.activeTodoCount,
  });

  factory ActiveTodoCountState.initial() {
    return ActiveTodoCountState(activeTodoCount: 0);
  }

  List<Object> get props => [activeTodoCount];

  bool get stringify => true;

  ActiveTodoCountState copywith({int? activeTodoCount}) {
    return ActiveTodoCountState(
        activeTodoCount: activeTodoCount ?? this.activeTodoCount);
  }
}

class ActiveTodoCount with ChangeNotifier {
  ActiveTodoCountState _state = ActiveTodoCountState.initial();
  ActiveTodoCountState get state => _state;

  void update(TodoList todoList) {
    final newActiveTodoCount = todoList.state.todos
        .where((Todo todo) => !todo.completed)
        .toList()
        .length;
    _state = _state.copywith(activeTodoCount: newActiveTodoCount);
    notifyListeners();
  }
}
