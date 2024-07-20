import 'package:case_be_heard/custom_widgets/loading.dart';
import 'package:case_be_heard/services/auth.dart';
import 'package:case_be_heard/shared/style.dart';
import 'package:case_be_heard/shared/utility.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  const SignIn({super.key, required this.toggleView});

  @override
  SignInState createState() => SignInState();
}

class SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text field state
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Loading();
    } else {
      return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(backgroundColor: Colors.white, elevation: 0.0),
          body: Container(
              padding: const EdgeInsets.all(20),
              child: Form(
                  key: _formKey,
                  child: ListView(children: <Widget>[
                    Image.asset('assets/case_logo_main.ico',
                        width: 150, height: 150, fit: BoxFit.cover),
                    const SizedBox(height: 20.0),
                    const Center(
                        child: Text('Sign into your community account',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 26, fontWeight: FontWeight.bold))),
                    const SizedBox(height: 20.0),
                    const Text('Email address', style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 10.0),
                    TextFormField(
                        style: const TextStyle(fontSize: 18.0),
                        decoration: Style.textInputDecoration
                            .copyWith(hintText: 'Enter email'),
                        validator: (val) =>
                            val!.isEmpty ? 'Enter an email' : null,
                        onChanged: (val) {
                          setState(() => email = val);
                        }),
                    const SizedBox(height: 20.0),
                    const Text('Password', style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 10.0),
                    TextFormField(
                        style: const TextStyle(fontSize: 18.0),
                        decoration: Style.textInputDecoration
                            .copyWith(hintText: 'Enter password'),
                        obscureText: true,
                        validator: (val) => val!.length < 6
                            ? 'Enter a password 6+ chars long'
                            : null,
                        onChanged: (val) {
                          setState(() => password = val);
                        }),
                    const SizedBox(height: 20.0),
                    ElevatedButton(
                        style: Style.buttonDecoration,
                        onPressed: () async {
                          if (_formKey.currentState != null &&
                              _formKey.currentState!.validate()) {
                            setState(() => loading = true);
                            dynamic result =
                                await AuthService.signInWithEmailAndPassword(
                                    email, password);
                            if (result == null) {
                              setState(() => loading = false);
                              if (context.mounted) {
                                Utility.showSnackBar(context,
                                    'Could not sign in with those credentials');
                              }
                            }
                          }
                        },
                        child: const Text('Sign In')),
                    const SizedBox(height: 20.0),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Text('Don\'t have an account?',
                          style: TextStyle(fontSize: 16)),
                      TextButton(
                          child: Text('Register',
                              style: Theme.of(context).textTheme.labelLarge),
                          onPressed: () => widget.toggleView())
                    ]),
                    const SizedBox(height: 40.0),
                    OutlinedButton.icon(
                        style: Style.buttonGoogleDecoration,
                        onPressed: () async {
                          dynamic result = await AuthService.signInWithGoogle();
                          if (result == null) {
                            setState(() => loading = false);
                          }
                        },
                        icon: const FaIcon(FontAwesomeIcons.google),
                        label: const Text('Login with Google'))
                  ]))));
    }
  }
}
