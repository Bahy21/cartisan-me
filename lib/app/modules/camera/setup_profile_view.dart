import 'package:cartisan/app/data/constants/constants.dart';
import 'package:cartisan/app/modules/camera/components/setup_dialog.dart';
import 'package:flutter/material.dart';

class SetupProfileView extends StatefulWidget {
  const SetupProfileView({super.key});

  @override
  State<SetupProfileView> createState() => _SetupProfileViewState();
}

class _SetupProfileViewState extends State<SetupProfileView> {

  @override
  void initState() {
     WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog<void>(
        context: context,
        builder: (context) => const SetupDialog(),
      );
    });
    super.initState();
    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Setup Profile', style: AppTypography.kBold16),
      ),
    );
  }
}
