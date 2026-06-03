import 'package:flutter/material.dart';

import 'package:sonority/gui/widgets/sonority_app_bar.dart';

class SongsListScreen extends StatefulWidget {
  const SongsListScreen({super.key});

  @override
  State<SongsListScreen> createState() => _SongsListScreenState();
}

class _SongsListScreenState extends State<SongsListScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SonorityAppBar(title: "My songs"),
      body: SafeArea(
        child: Column()
      )
    );
  }
}
