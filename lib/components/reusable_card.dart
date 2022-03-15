

import 'package:flutter/material.dart';

class ReusableCard extends StatelessWidget {
  final String label;

  // ignore: use_key_in_widget_constructors
  const ReusableCard({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child:  Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 70.0),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style:const TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
