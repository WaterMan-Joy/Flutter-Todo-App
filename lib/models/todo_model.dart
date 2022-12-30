import 'package:uuid/uuid.dart';

Uuid uuid = Uuid();

class Todo {
  final String id;
  final String desc;
  final bool completed;

  Todo({
    String? id,
    required this.desc,
    this.completed = false,
  }) : id = id ?? uuid.v4();

  List<Object> get props => [id, desc, completed];

  bool get stringify => true;
}

enum Filter {
  all,
  active,
  completed,
}
