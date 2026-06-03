import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final double size;
  final Color color;
  final bool boolText;
  final VoidCallback onPressed;

  const MenuButton({
    super.key,
    required this.icon,
    required this.label,
    this.size = 60,
    required this.color,
    this.boolText = false,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      child: IntrinsicWidth(
        child: Row(
          spacing: 15,
          children: [
            SizedBox(width: size, child: Icon(icon, size: size, color: color)),
            Text(
              label,
              style: TextStyle(
                fontSize: size - 20,
                fontWeight: boolText ? FontWeight.bold : FontWeight.normal,
                color: color
              ),
            ),
          ],
        ),
      ),
    );
  }
}
