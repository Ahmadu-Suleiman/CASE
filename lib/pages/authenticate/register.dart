import 'package:case_be_heard/custom_widgets/loading.dart';
import 'package:case_be_heard/services/auth.dart';
import 'package:case_be_heard/shared/style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../models/community_member.dart';
import '../intro_screens/confirm_details_page.dart';
import '../intro_screens/create_profile_page.dart';
import '../intro_screens/register_page.dart';

class Register extends StatefulWidget {
  // final Function toggleView;

  const Register({super.key});

  @override
  RegisterState createState() => RegisterState();
}

class RegisterState extends State<Register> {
  int currentStep = 0;
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text field state
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Consumer2<User?, CommunityMember?>(
        builder: (context, user, member, child) {
      if (user == null) {
        currentStep = 0;
      } else {
        currentStep = 1;
      }
      return Scaffold(
          appBar: AppBar(title: const Text('R E G I S T R A T I O N')),
          body: Stepper(
              type: StepperType.horizontal,
              elevation: 2.0,
              steps: getSteps(),
              currentStep: currentStep,
              onStepContinue: () async {
                // if in profile page
                if (currentStep == 1) {}
                // if in confirm-profile page
                if (currentStep == 2) {}

                // final isLastStep = (currentStep == getSteps().length - 1);
                // if (!isLastStep) {
                //   setState(() => currentStep++);
                // }
              },
              onStepCancel: () {
                if (currentStep == 0) {
                  return;
                } else {
                  setState(() {
                    currentStep--;
                  });
                }
              },
              controlsBuilder: (BuildContext context, ControlsDetails details) {
                return Container(
                    margin: const EdgeInsets.only(top: 50.0),
                    child: Row(children: [
                      if (currentStep != 0)
                        Expanded(
                            child: ElevatedButton(
                                onPressed: details.onStepCancel,
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.deepPurple,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0))),
                                child: const Text('Back',
                                    style: TextStyle(color: Colors.white)))),
                      const SizedBox(width: 12.0),
                      if (currentStep != 0)
                        Expanded(
                            child: ElevatedButton(
                                onPressed: details.onStepContinue,
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.deepPurple,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0))),
                                child: const Text('Next',
                                    style: TextStyle(color: Colors.white))))
                    ]));
              }));
    });

    return loading
        ? const Loading()
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(backgroundColor: Colors.white, elevation: 0.0),
            body: Container(
                padding: const EdgeInsets.all(20),
                child: Form(
                    key: _formKey,
                    child: ListView(children: <Widget>[
                      const SizedBox(height: 20.0),
                      const Center(
                          child: Text('Register your community account',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 26, fontWeight: FontWeight.bold))),
                      const SizedBox(height: 20.0),
                      const Text('Email address',
                          style: TextStyle(fontSize: 16)),
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
                      TextFormField(
                          style: const TextStyle(fontSize: 18.0),
                          decoration: Style.textInputDecoration
                              .copyWith(hintText: 'Confirm password'),
                          obscureText: true,
                          validator: (val) =>
                              val != password ? 'Password not matching' : null),
                      const SizedBox(height: 20.0),
                      ElevatedButton(
                          style: Style.buttonDecoration,
                          onPressed: () async {
                            if (_formKey.currentState != null &&
                                _formKey.currentState!.validate()) {
                              setState(() => loading = true);
                              dynamic result = await AuthService
                                  .registerWithEmailAndPassword(
                                      email, password);
                              if (result == null) {
                                setState(() => loading = false);
                              }
                            }
                          },
                          child: const Text('Register')),
                      const SizedBox(height: 20.0),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Already have an account?',
                                style: TextStyle(fontSize: 16)),
                            TextButton(
                                child: Text('Sign In',
                                    style:
                                        Theme.of(context).textTheme.labelLarge),
                                onPressed: () {}
                                // widget.toggleView()
                                )
                          ]),
                      const SizedBox(height: 40.0),
                      OutlinedButton.icon(
                          style: Style.buttonGoogleDecoration,
                          onPressed: () async {
                            dynamic result =
                                await AuthService.signInWithGoogle();
                            if (result == null) {
                              setState(() => loading = false);
                            }
                          },
                          icon: const FaIcon(FontAwesomeIcons.google),
                          label: const Text('Login with Google'))
                    ]))));
  }

  List<Step> getSteps() => [
        Step(
            state: currentStep > 0 ? StepState.complete : StepState.indexed,
            title: const Text('Account details'),
            content: RegisterPage(nextStep: () => setState(() {})),
            isActive: currentStep >= 0),
        Step(
            state: currentStep > 1 ? StepState.complete : StepState.indexed,
            title: const Text('Profile Details'),
            content: const CreateProfilePage(),
            isActive: currentStep >= 1),
        Step(
            title: const Text('Complete'),
            content: const ConfirmDetailsPage(),
            isActive: currentStep >= 2),
      ];
}
