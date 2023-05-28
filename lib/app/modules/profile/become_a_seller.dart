import 'package:flutter/material.dart';

class BecomeASeller extends StatefulWidget {
  const BecomeASeller({super.key});

  @override
  State<BecomeASeller> createState() => _BecomeASellerState();
}

class _BecomeASellerState extends State<BecomeASeller> {
  final _stateController = TextEditingController();
  final _taxController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
