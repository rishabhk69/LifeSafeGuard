import 'package:flutter/material.dart';

class BuilderDialog extends StatelessWidget {
  const BuilderDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 60.0,
        height: 60.0,
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(
            color: Colors.grey,
            blurRadius: 5.0,
          ),],
          color: Colors.white,
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
