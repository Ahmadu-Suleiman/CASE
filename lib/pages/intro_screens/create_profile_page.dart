import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

enum SelectedGender { male, female }

class CreateProfilePage extends StatefulWidget {
  const CreateProfilePage({super.key});

  @override
  State<CreateProfilePage> createState() => _CreateProfilePageState();
}

class _CreateProfilePageState extends State<CreateProfilePage> {
  // ValueNotifier<String?> selectedGender = ValueNotifier<String?>(null);

  SelectedGender? _selectedGender;

  final firstName = TextEditingController(),
      lastName = TextEditingController(),
      phoneNumber = TextEditingController(),
      occupation = TextEditingController(),
      address = TextEditingController(),
      bio = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(children: [
        TextFormField(
          controller: firstName,
          decoration: reusedInputDecoration(
              labelText: 'First Name', hintText: 'Enter your first name'),
        ),
        const SizedBox(
          height: 15,
        ),
        TextFormField(
          controller: lastName,
          decoration: reusedInputDecoration(
              labelText: 'Last Name', hintText: 'Enter your last name'),
        ),
        const SizedBox(
          height: 15,
        ),
        IntlPhoneField(
          initialCountryCode: 'NG',
          controller: phoneNumber,
          decoration: reusedInputDecoration(
              labelText: 'Phone Number', hintText: 'Enter your phone number'),
        ),
        const SizedBox(
          height: 15,
        ),
        TextFormField(
          controller: occupation,
          decoration: reusedInputDecoration(
              labelText: 'Occupation', hintText: 'Enter your Occupation'),
        ),
        const SizedBox(
          height: 15,
        ),
        const Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Select your gender:',
              style: TextStyle(fontSize: 15.0),
            )),
        const SizedBox(
          height: 10.0,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black12, // Set border color
              width: 2.0, // Set border width
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: RadioListTile<SelectedGender>(
                  title: const Text('Male'),
                  value: SelectedGender.male,
                  groupValue: _selectedGender,
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value;
                    });
                  },
                ),
              ),
              Expanded(
                child: RadioListTile<SelectedGender>(
                  title: const Text('Female'),
                  value: SelectedGender.female,
                  groupValue: _selectedGender,
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        const Align(
          alignment: Alignment.topLeft,
          child: Text(
            'Address:',
            style: TextStyle(fontSize: 15.0),
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        //REPLACE THIS WITH THE GPS LOCATION THINGY
        GestureDetector(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            height: 50.0,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 49, 84, 201),
              border: Border.all(color: Colors.black12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              children: [
                Icon(Icons.location_on),
                SizedBox(
                  width: 40.0,
                ),
                Text(
                  'Choose your location',
                  style: TextStyle(fontSize: 18.0),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 35,
        ),
        TextFormField(
          controller: bio,
          maxLength: 200,
          keyboardType: TextInputType.multiline,
          maxLines: 5, // Maximum number of lines the field can span
          decoration: reusedInputDecoration(
              labelText: 'Bio', hintText: 'Tell us more about yourself'),
        ),
      ]),
    );
  }
}

InputDecoration reusedInputDecoration(
    {required String labelText, required String hintText}) {
  return InputDecoration(
    labelText: labelText,
    hintText: hintText,
    hintStyle: const TextStyle(
      color: Colors.black26,
    ),
    border: OutlineInputBorder(
      borderSide: const BorderSide(
        color: Colors.black12, // Default border color
      ),
      borderRadius: BorderRadius.circular(10),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        color: Colors.black12, // Default border color
      ),
      borderRadius: BorderRadius.circular(10),
    ),
  );
}
