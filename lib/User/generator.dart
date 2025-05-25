import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class Generator extends StatefulWidget {
  final String code;
  const Generator({super.key, required this.code});

  @override
  State<Generator> createState() => _GeneratorState();
}

class _GeneratorState extends State<Generator> {
  TextEditingController urlContorller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Generator"),),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                QrImageView(
                  data: widget.code,
                  size:200,
                ),
              const SizedBox(height: 10,),
            ],
          ),
        ),
      ),
    );
  }
}
