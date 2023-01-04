// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:state_notifier/state_notifier.dart';

class TodoSearchState {
  final String searchTerm;
  TodoSearchState({
    required this.searchTerm,
  });

  factory TodoSearchState.initial() {
    return TodoSearchState(searchTerm: '');
  }

  TodoSearchState copywith({String? searchTerm}) {
    return TodoSearchState(searchTerm: searchTerm ?? this.searchTerm);
  }
}

class TodoSearch extends StateNotifier<TodoSearchState> {
  TodoSearch() : super(TodoSearchState.initial());

  void setSearchTerm(String newSearchTerm) {
    state = state.copywith(searchTerm: newSearchTerm);
  }
}
