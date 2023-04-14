import 'package:cartisan/app/data/constants/constants.dart';
import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  final String text;

  const ExpandableText({
    required this.text,
    super.key,
  });

  @override
  // ignore: library_private_types_in_public_api
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  late String firstHalf;
  late String secondHalf;

  bool flag = true;

  @override
  void initState() {
    super.initState();

    if (widget.text.length > 120) {
      firstHalf = widget.text.substring(0, 120);
      secondHalf = widget.text.substring(120, widget.text.length);
    } else {
      firstHalf = widget.text;
      secondHalf = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return secondHalf.isEmpty
        ? Text(firstHalf)
        : Wrap(
            children: <Widget>[
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: flag
                    ? Text('$firstHalf...', key: UniqueKey())
                    : Text('$firstHalf$secondHalf', key: UniqueKey()),
              ),
              InkWell(
                child: Text(
                  flag ? 'Read Full' : 'Read Less',
                  style: AppTypography.kBold14.copyWith(
                    color: AppColors.kPrimary,
                  ),
                ),
                onTap: () {
                  setState(() {
                    flag = !flag;
                  });
                },
              ),
            ],
          );
  }
}
