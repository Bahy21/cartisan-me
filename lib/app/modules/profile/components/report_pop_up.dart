import 'package:flutter/material.dart';

class ReportPopup extends StatefulWidget {
  final void Function(dynamic) onItemSelected;

  const ReportPopup({
    required this.onItemSelected,
    super.key,
  });

  @override
  _ReportPopupState createState() => _ReportPopupState();
}

class _ReportPopupState extends State<ReportPopup> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: (value) => widget.onItemSelected(value),
      itemBuilder: (context) {
        return [
          const PopupMenuItem(
            value: 1,
            child: Text('Report'),
          ),
          const PopupMenuItem(
            value: 2,
            child: Text('Block'),
          ),
        ];
      },
    );
  }
}
