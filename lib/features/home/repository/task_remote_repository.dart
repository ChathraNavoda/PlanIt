import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:planit/core/constants/constants.dart';
import 'package:planit/features/home/repository/task_local_repository.dart';
import 'package:planit/models/task_model.dart';

class TaskRemoteRepository {
  final taskLocalRepository = TaskLocalRepository();

  Future<TaskModel> createTask({
    required String title,
    required String description,
    required String hexColor,
    required String token,
    required DateTime dueAt,
  }) async {
    try {
      final res = await http.post(
        Uri.parse("${Constants.backendUri}/tasks"),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
        body: jsonEncode({
          'title': title,
          'description': description,
          'hexColor': hexColor,
          'dueAt': dueAt.toIso8601String(),
        }),
      );
      if (res.statusCode != 201) {
        throw jsonDecode(res.body)['msg'];
      }
      return TaskModel.fromJson(res.body);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<TaskModel>> getTask({required String token}) async {
    try {
      final res = await http.get(
        Uri.parse("${Constants.backendUri}/tasks"),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
      );
      if (res.statusCode != 200) {
        throw jsonDecode(res.body)['msg'];
      }

      final listOfTasks = jsonDecode(res.body);
      List<TaskModel> tasksList = [];

      for (var elem in listOfTasks) {
        tasksList.add(TaskModel.fromMap(elem));
      }
      return tasksList;
    } catch (e) {
      final tasks = await taskLocalRepository.getTasks();
      if (tasks.isNotEmpty) {
        return tasks;
      }
      rethrow;
    }
  }
}
