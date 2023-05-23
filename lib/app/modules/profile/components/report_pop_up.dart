import 'package:flutter/material.dart';

class ReportPopup extends StatefulWidget {
  final void Function(int)? onSelected;

  const ReportPopup({super.key, this.onSelected});

  @override
  _ReportPopupState createState() => _ReportPopupState();
}

class _ReportPopupState extends State<ReportPopup> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: widget.onSelected,
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
