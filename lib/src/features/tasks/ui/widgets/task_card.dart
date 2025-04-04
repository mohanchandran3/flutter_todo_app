import 'package:flutter/material.dart';
import 'package:flutter_todo_app/src/core/widgets/custom_checkbox.dart';
import 'package:flutter_todo_app/src/features/tasks/models/task_model.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;
  final VoidCallback onTap;
  final Function(bool?) onComplete;

  const TaskCard({
    required this.task,
    required this.onTap,
    required this.onComplete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = task.isCompleted ? Colors.lightBlue[50] : Colors.red[50];

    return Card(
      color: cardColor,
      elevation: 4,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomCheckbox(
                value: task.isCompleted,
                onChanged: onComplete,
                activeColor: Colors.blue,
                inactiveBorderColor: Colors.grey[500]!,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          task.isCompleted ? Icons.check_circle : Icons.pending,
                          color:
                              task.isCompleted ? Colors.blue : Colors.redAccent,
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            task.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color:
                                  task.isCompleted
                                      ? Colors.grey[600]
                                      : Colors.black87,
                              decoration:
                                  task.isCompleted
                                      ? TextDecoration.lineThrough
                                      : null,
                              decorationColor: Colors.grey[400],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      task.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
