import 'package:flutter/material.dart';
import 'package:untitled/services/auth/auth_service.dart';
import 'package:untitled/views/login_view.dart';
import 'package:untitled/views/notes_view.dart';
import 'package:untitled/views/register_view.dart';
import 'package:untitled/views/verify_email_view.dart';

import 'constants/routes.dart';

void main() {
  // Ensure widget system initialized before executing dependency actions
  // Before using runApp()
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
    ),
    home: const HomePage(),
    routes: {
      loginRoute: (context) => const LoginView(),
      registerRoute: (context) => const RegisterView(),
      notesRoute: (context) => const NotesView(),
      verifyEmailRoute: (context) => const VerifyEmailView(),
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: AuthService.firebase().initialize(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = AuthService.firebase().currentUser;
              if (user != null) {
                if (user.isEmailVerified) {
                  return const NotesView();
                } else {
                  return const VerifyEmailView();
                }
              } else {
                return const LoginView();
              }
            default:
              return CircularProgressIndicator();
          }
        });
  }
}
