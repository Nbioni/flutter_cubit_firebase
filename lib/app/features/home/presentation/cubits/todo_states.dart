import '../../../../core/data/models/todo_model.dart';

abstract class TodoState {}

class InitialTodoState extends TodoState {}

class LoadingTodoState extends TodoState {}

class LoadedTodoState extends TodoState {
  final List<TodoModel> todos;
  LoadedTodoState(this.todos);
}

class ErrorTodoState extends TodoState {
  final String message;
  ErrorTodoState(this.message);
}