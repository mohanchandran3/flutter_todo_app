import 'package:flutter/material.dart';

class CustomCheckbox extends StatelessWidget {
  final bool value;
  final Function(bool?) onChanged;
  final Color activeColor;
  final Color inactiveBorderColor;

  const CustomCheckbox({
    required this.value,
    required this.onChanged,
    this.activeColor = Colors.blue,
    this.inactiveBorderColor = const Color(0xFF9E9E9E),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: value ? activeColor : inactiveBorderColor,
            width: 2,
          ),
          color: value ? activeColor : Colors.transparent,
        ),
        child:
            value
                ? const Icon(Icons.check, size: 16, color: Colors.white)
                : null,
      ),
    );
  }
}
