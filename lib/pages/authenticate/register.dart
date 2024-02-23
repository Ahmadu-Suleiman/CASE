import 'package:case_be_heard/custom_widgets/loading.dart';
import 'package:case_be_heard/services/auth.dart';
import 'package:case_be_heard/shared/style.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  const Register({super.key, required this.toggleView});

  @override
  RegisterState createState() => RegisterState();
}

class RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;

  // text field state
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Scaffold(
            backgroundColor: Colors.brown[100],
            appBar: AppBar(
              backgroundColor: Colors.brown[400],
              elevation: 0.0,
              title: const Text('Sign up to Brew Crew'),
              actions: <Widget>[
                TextButton.icon(
                  icon: const Icon(Icons.person),
                  label: const Text('Sign In'),
                  onPressed: () => widget.toggleView(),
                ),
              ],
            ),
            body: Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 50.0),
                child: Form(
                    key: _formKey,
                    child: Column(children: <Widget>[
                      const SizedBox(height: 20.0),
                      TextFormField(
                          decoration: Style.textInputDecoration
                              .copyWith(hintText: 'email'),
                          validator: (val) =>
                              val!.isEmpty ? 'Enter an email' : null,
                          onChanged: (val) {
                            setState(() => email = val);
                          }),
                      const SizedBox(height: 20.0),
                      TextFormField(
                          decoration: Style.textInputDecoration
                              .copyWith(hintText: 'password'),
                          obscureText: true,
                          validator: (val) => val!.length < 6
                              ? 'Enter a password 6+ chars long'
                              : null,
                          onChanged: (val) {
                            setState(() => password = val);
                          }),
                      const SizedBox(height: 20.0),
                      ElevatedButton(
                          style: const ButtonStyle(
                              iconColor:
                                  MaterialStatePropertyAll<Color>(Colors.pink)),
                          child: const Text(
                            'Register',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState != null &&
                                _formKey.currentState!.validate()) {
                              setState(() => loading = true);
                              dynamic result = await AuthService
                                  .registerWithEmailAndPassword(
                                      email, password);
                              if (result == null) {
                                setState(() {
                                  loading = false;
                                  error = 'Please supply a valid email';
                                });
                              }
                            }
                          }),
                      GestureDetector(
                          onTap: () async {
                            dynamic result =
                                await AuthService.signInWithGoogle();
                            if (result == null) {
                              setState(() {
                                loading = false;
                                error = 'Registration failed';
                              });
                            }
                          },
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset('asset/google.svg'),
                                const Text('Register with Google')
                              ])),
                      const SizedBox(height: 12.0),
                      Text(error,
                          style: const TextStyle(
                              color: Colors.red, fontSize: 14.0))
                    ]))));
  }
}
