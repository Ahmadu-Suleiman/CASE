import 'package:flutter/material.dart';

class ConfirmDetailsPage extends StatefulWidget {
  const ConfirmDetailsPage({super.key});

  @override
  State<ConfirmDetailsPage> createState() => _ConfirmDetailsPageState();
}

class _ConfirmDetailsPageState extends State<ConfirmDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Email:',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('First Name:'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Last Name:'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Phone Number:'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Occupation:'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Address:'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Bio:'),
          ],
        ),
      ],
    );
  }
}
