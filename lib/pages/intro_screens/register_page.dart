import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import '../../services/auth.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({
    super.key,
    required this.nextStep,
  });

  final void Function() nextStep;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  bool _passwordVisible = false;

  void _togglePasswordVisibility() {
    setState(() => _passwordVisible = !_passwordVisible);
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Form(
          key: _formKey,
          child: Column(children: [
            TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.email],
                decoration: inputDecoration(
                        labelText: 'Enter your Email Address',
                        hintText: 'Email address')
                    .copyWith(prefixIcon: const Icon(Icons.email)),
                validator: (email) {
                  return email != null && EmailValidator.validate(email)
                      ? null
                      : 'Enter a valid email';
                }),
            const SizedBox(height: 20),
            TextFormField(
                controller: _passwordController,
                obscureText: !_passwordVisible,
                decoration: inputDecoration(
                        labelText: 'Enter Password', hintText: 'password')
                    .copyWith(
                        prefixIcon: const Icon(Icons.password),
                        suffixIcon: IconButton(
                            icon: Icon(_passwordVisible
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: _togglePasswordVisibility))),
            const SizedBox(height: 20),
            TextFormField(
                obscureText: !_passwordVisible,
                decoration: inputDecoration(
                        labelText: 'Confirm Password', hintText: 'Password')
                    .copyWith(
                        prefixIcon: const Icon(Icons.password),
                        suffixIcon: IconButton(
                            icon: Icon(_passwordVisible
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: _togglePasswordVisibility)))
          ])),
      const SizedBox(height: 20),
      Row(children: [
        const Text('Already have an account?',
            style: TextStyle(fontSize: 15.0)),
        const SizedBox(width: 12.0),
        GestureDetector(
            onTap: () {},
            child: const Text('Log In',
                style: TextStyle(fontSize: 15.0, color: Colors.blue)))
      ]),
      const SizedBox(height: 70.0),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Expanded(
            child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState != null &&
                      _formKey.currentState!.validate()) {
                    setState(() => _loading = true);
                    await AuthService.registerWithEmailAndPassword(
                        _emailController.text, _passwordController.text);
                    widget.nextStep();
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    maximumSize: const Size(double.infinity, 50)),
                child: _loading
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.onPrimary),
                      )
                    : const Text('Register',
                        style: TextStyle(color: Colors.white))))
      ])
    ]);
  }
}

InputDecoration inputDecoration(
    {required String labelText, required String hintText}) {
  return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      hintStyle: const TextStyle(color: Colors.black26),
      border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black12),
          borderRadius: BorderRadius.circular(10)),
      enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black12),
          borderRadius: BorderRadius.circular(10)));
}
