import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DurationComponent extends StatelessWidget {
  const DurationComponent({
    required this.controller,
    required this.label,
    required this.onChanged,
    required this.flex,
    this.icon,
    super.key,
  });

  final TextEditingController controller;
  final String label;
  final void Function(int) onChanged;
  final Widget? icon;
  final int flex;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          icon: icon,
          labelText: label,
        ),
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly,
        ],
        keyboardType: TextInputType.number,
        onChanged: (text) => onChanged(int.tryParse(text, radix: 10) ?? 0),
      ),
    );
  }
}
