import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/data/models/todo_model.dart';

class TodoForm extends StatefulWidget {
  final Future<void> Function({required TodoModel todoModel}) onSavePressed;
  final TodoModel? model;

  const TodoForm({super.key, required this.onSavePressed, required this.model});

  @override
  State<TodoForm> createState() => _TodoFormState();
}

class _TodoFormState extends State<TodoForm> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  TodoModelPriority _priority = TodoModelPriority.low;

  bool _isTitleEmpty = true; 

  @override
  void initState() {
    super.initState();
    _titleController.addListener(_onTitleChanged);
    if(widget.model != null){
      _titleController.text = widget.model!.title ?? '';
      _descriptionController.text = widget.model!.description ?? '';
      if(widget.model!.priority != null){
        setState(() {
          _priority = widget.model!.priority!;
        });
      }
    }
  }

  void _onTitleChanged() {
    setState(() {
      _isTitleEmpty = _titleController.text.isEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isEditing = widget.model != null;
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(isEditing ? 'Edit Task' : 'New Task'),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      insetPadding: const EdgeInsets.only(left: 20, right: 20, bottom: 30, top: 5),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      content: Column(
        children: [
          const SizedBox(height: 10, width: double.maxFinite),
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Title'),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(labelText: 'Description'),
          ),
          const SizedBox(height: 30),
          Column(
            children: [
              const Text(
                'Priority',
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 5),
              ToggleButtons(
                isSelected: [
                  _priority == TodoModelPriority.low,
                  _priority == TodoModelPriority.medium,
                  _priority == TodoModelPriority.high,
                ],
                onPressed: (int index) {
                  setState(() {
                    if (index == 0) {
                      _priority = TodoModelPriority.low;
                    } else if (index == 1) {
                      _priority = TodoModelPriority.medium;
                    } else {
                      _priority = TodoModelPriority.high;
                    }
                  });
                },
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Column(
                      children: [
                        Text('Low'),
                        SizedBox(height: 5),
                        Icon(Icons.arrow_circle_down_outlined)
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Column(
                      children: [
                        Text('Medium'),
                        SizedBox(height: 5),
                        Icon(Icons.arrow_circle_right_outlined, color: Colors.orangeAccent)
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Column(
                      children: [
                        Text('High'),
                        SizedBox(height: 5),
                        Icon(Icons.arrow_circle_up_outlined, color: Colors.redAccent)
                      ],
                    ),
                  ),
                ],
              )
            ],
          )
          
        ],
      ),
      actions: [
        if(isEditing)
          OutlinedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.redAccent), // Definindo a cor da borda como vermelha
            ),
            child: const Text('REMOVE', style: TextStyle(color: Colors.redAccent),),
          ),
        FilledButton(
          onPressed: _isTitleEmpty ? null : () {
            const uuid = Uuid();
            TodoModel todoModel = TodoModel(
              id: widget.model?.id ?? uuid.v4(),
              title: _titleController.text,
              description: _descriptionController.text,
              priority: _priority,
              isDone: false,
            );
            widget.onSavePressed(todoModel: todoModel);
            Navigator.pop(context);
          },
          child: Text(isEditing ? 'UPDATE' : 'CREATE'),
        ),
      ],
    );
  }
}