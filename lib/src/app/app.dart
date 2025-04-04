import 'package:flutter/material.dart';
import 'package:flutter_todo_app/src/core/di/injector.dart';
import 'package:flutter_todo_app/src/core/routes/route_generator.dart';
import 'package:flutter_todo_app/src/core/theme/app_theme.dart';
import 'package:flutter_todo_app/src/core/utils/auth_wrapper.dart';
import 'package:provider/provider.dart';

class ToDoApp extends StatelessWidget {
  const ToDoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: Providers.allProviders,
      child: MaterialApp(
        title: 'MyToDo',
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        onGenerateRoute: RouteGenerator.generateRoute,
        home: const AuthWrapper(),
      ),
    );
  }
}