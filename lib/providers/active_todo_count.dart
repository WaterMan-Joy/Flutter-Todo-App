// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:state_notifier/state_notifier.dart';

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

  ActiveTodoCountState copywith({int? activeTodoCount}) {
    return ActiveTodoCountState(
        activeTodoCount: activeTodoCount ?? this.activeTodoCount);
  }
}

class ActiveTodoCount extends StateNotifier<ActiveTodoCountState>
    with LocatorMixin {
  ActiveTodoCount() : super(ActiveTodoCountState.initial());

  @override
  void update(Locator watch) {
    final List<Todo> todos = watch<TodoListState>().todos;
    state = state.copywith(
        activeTodoCount:
            todos.where((Todo todo) => !todo.completed).toList().length);
    print(state);
    super.update(watch);
  }
}
