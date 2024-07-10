import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/data/models/todo_model.dart';
import '../../../../core/data/source/firebase_service.dart';
import 'todo_states.dart';

class TodoCubit extends Cubit<TodoState> {
  TodoCubit() : super(InitialTodoState());

  final _firebaseService = FirebaseService();
  List<TodoModel> _todos = [];
  List<TodoModel> get todos => _todos;

  Future<void> fetchTodoList() async {
    emit(LoadingTodoState());
    List<TodoModel> todoList = await _firebaseService.getTodoList();
    _todos = todoList;
    emit(LoadedTodoState(_todos));
  }

  Future<void> addTodo({ required TodoModel todoModel }) async {
    emit(LoadingTodoState());
    await _firebaseService.addTodo(todoModel);
    _todos.add(todoModel);
    emit(LoadedTodoState(_todos));
  }

  Future<void> updateTodo({ required TodoModel todoModel }) async {
    emit(LoadingTodoState());
    await _firebaseService.updateTodo(todoModel);
    fetchTodoList();
  }

  Future<void> removeTodo({ required int index }) async {
    emit(LoadingTodoState());
    await Future.delayed(const Duration(milliseconds: 200));
    _todos.removeAt(index);
    emit(LoadedTodoState(_todos));
  }
}
