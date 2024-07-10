import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cubit_firebase/app/features/auth/presentation/cubits/auth_states.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/data/models/todo_model.dart';
import '../../../../core/data/utils/constants/app_routes.dart';
import '../../../auth/presentation/cubits/auth_cubit.dart';
import '../cubits/todo_cubit.dart';
import '../cubits/todo_states.dart';
import '../widgets/profile_drawer.dart';
import '../widgets/todo_form.dart';
import '../widgets/todo_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final TodoCubit todoCubit;
  late final AuthCubit authCubit;
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    todoCubit = BlocProvider.of<TodoCubit>(context);
    authCubit = BlocProvider.of<AuthCubit>(context);
    if(todoCubit.state is InitialTodoState && todoCubit.todos.isEmpty){
      todoCubit.fetchTodoList();
    }
    if(authCubit.state is LoggedInAuthState && authCubit.userModel != null && authCubit.userModel?.profileImageUrl == null){
      authCubit.fetchUserModel();
    }
  }

  void _handleOnEdit(int index) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return TodoForm(
          onSavePressed: ({ required TodoModel todoModel }) async { 
            todoCubit.updateTodo(todoModel: todoModel);
          }, 
          model: todoCubit.todos[index],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileImageUrl = authCubit.userModel?.profileImageUrl;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          Builder(
            builder: (context) {
              return TextButton(
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
                child: CircleAvatar(
                  backgroundImage: profileImageUrl != null ? NetworkImage(profileImageUrl) : null,
                  child: profileImageUrl != null ? null : const Icon(Icons.person),
                ),
              );
            }
          ),
        ],
      ),
      body: BlocBuilder<TodoCubit, TodoState>(
        builder: (context, state) {
          if(state is InitialTodoState){
            return const Center(child: Text('Add a task'));
          } else if (state is LoadingTodoState){
            return const Center(child: CircularProgressIndicator());
          } else if (state is LoadedTodoState){
            return TodoList(
              todos: state.todos, 
              onEdit: _handleOnEdit,
            );
          } else if (state is ErrorTodoState){
            Fluttertoast.showToast(
              msg: state.message,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.SNACKBAR,
              backgroundColor: Colors.black54,
              textColor: Colors.white,
              fontSize: 14.0,
            );
            return TodoList(
              todos: todoCubit.todos, 
              onEdit: _handleOnEdit,
            );
          } else{
            return TodoList(
              todos: todoCubit.todos, 
              onEdit: _handleOnEdit,
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _nameController.clear();
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return TodoForm(
                onSavePressed: ({ required TodoModel todoModel }) async { 
                  todoCubit.addTodo(todoModel: todoModel);
                },
                model: null,
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
      endDrawer: Drawer(
        child: Builder(
          builder: (context) {
            return ProfileDrawer(
              userModel: authCubit.userModel, 
              logout: () { 
                Navigator.pushReplacementNamed(context, AppRoutes.login);
                authCubit.logout(); 
              },
              uploadProfileImage: (XFile file) {
                authCubit.uploadProfileImage(file);
              },
            );
          }
        ),
      ),
    );
  }
}

