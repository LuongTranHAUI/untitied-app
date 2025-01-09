import 'package:flutter/material.dart';
import 'package:untitled/constants/routes.dart';
import 'package:untitled/services/auth/auth_service.dart';

import '../services/auth/auth_exceptions.dart';
import '../utilities/show_error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: 'Enter you email here'),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            decoration:
                const InputDecoration(hintText: 'Enter you password here'),
          ),
          TextButton(
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;
                try {
                  await AuthService.firebase().createUser(
                    email: email,
                    password: password,
                  );
                  AuthService.firebase().sendEmailVerification();
                  Navigator.of(context).pushNamed(verifyEmailRoute);
                } on WeekPasswordAuthException {
                  await showErrorDialog(context, 'Weak password');
                } on EmailAlreadyInUseAuthException {
                  await showErrorDialog(context, 'Email already in use');
                } on InvalidEmailAuthException {
                  await showErrorDialog(context, 'Invalid email entered');
                } on GenericAuthException {
                  await showErrorDialog(context, 'Authentication error');
                }
              },
              child: const Text('Register')),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(loginRoute, (route) => false);
              },
              child: const Text("Have account already? Login now!"))
        ],
      ),
    );
  }
}
