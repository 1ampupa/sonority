import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            'Sonority',
            style: TextStyle(color: Colors.white, fontSize: 24),
          )
        ),
      )
    )
  );
}
