// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';

import '../models/todo_model.dart';

class TodoFilterState {
  final Filter filter;
  TodoFilterState({
    required this.filter,
  });

  // copywith of TodoFilterState type
  TodoFilterState copywith({Filter? filter}) {
    return TodoFilterState(
      filter: filter ?? this.filter,
    );
  }

  // singletone pattern
  factory TodoFilterState.initial() {
    return TodoFilterState(filter: Filter.all);
  }
}

// ChangeNotifier
class TodoFilter with ChangeNotifier {
  // _state initial()
  TodoFilterState _state = TodoFilterState.initial();
  TodoFilterState get state => _state;

  // new filter
  void ChangeFilter(Filter newFilter) {
    _state = _state.copywith(filter: newFilter);
    notifyListeners();
  }
}
