import 'package:flutter/material.dart';

class SonorityAppBar extends StatelessWidget implements PreferredSizeWidget{
  final String title;

  const SonorityAppBar({
    super.key,
    this.title = "Sonority" // Default App Bar
  });

  @override
  Size get preferredSize => const Size.fromHeight(40.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onPrimary
        )
      ),
      backgroundColor: Theme.of(context).colorScheme.primary
    );
  }
}
