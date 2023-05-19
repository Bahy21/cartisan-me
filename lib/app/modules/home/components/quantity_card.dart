import 'package:cartisan/app/data/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuantityCard extends StatefulWidget {
  final ValueChanged<int> onChanged;
  final bool isCartView;
  int quantity;
  QuantityCard({
    required this.quantity,
    required this.onChanged,
    this.isCartView = false,
    super.key,
  });

  @override
  State<QuantityCard> createState() => _QuantityCardState();
}

class _QuantityCardState extends State<QuantityCard> {
  void incrementQuantity() {
    setState(() {
      widget.quantity++;
    });
    widget.onChanged(widget.quantity);
  }

  void decrementQuantity() {
    if (widget.quantity > 1) {
      setState(() {
        widget.quantity--;
      });
      widget.onChanged(widget.quantity);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!widget.isCartView)
          Text('Quantity :', style: AppTypography.kBold14)
        else
          const SizedBox(),
        if (!widget.isCartView) SizedBox(height: 10.h) else const SizedBox(),
        Row(
          children: [
            QuantityValueCard(
              isDisabled: widget.quantity <= 1,
              onTap: decrementQuantity,
              icon: Icons.remove,
              isCartView: widget.isCartView,
            ),
            SizedBox(width: AppSpacing.tenHorizontal),
            Text(
              widget.quantity.toString(),
              style: widget.isCartView
                  ? AppTypography.kMedium14
                  : AppTypography.kMedium16,
            ),
            SizedBox(width: AppSpacing.tenHorizontal),
            QuantityValueCard(
              isDisabled: false,
              onTap: incrementQuantity,
              icon: Icons.add,
              isCartView: widget.isCartView,
            ),
          ],
        ),
      ],
    );
  }
}

class QuantityValueCard extends StatelessWidget {
  final bool isDisabled;
  final VoidCallback onTap;
  final IconData icon;
  final bool isCartView;
  const QuantityValueCard({
    required this.isDisabled,
    required this.onTap,
    required this.icon,
    this.isCartView = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final buttonColor = AppColors.kWhite.withOpacity(isDisabled ? 0.5 : 1);
    return InkWell(
      onTap: onTap,
      child: Container(
        height: isCartView ? 18.h : 27.h,
        width: isCartView ? 18.0.h : 27.0.h,
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(isCartView ? 100.h : AppSpacing.tenRadius),
          border: Border.all(
            color: buttonColor,
            width: 1.w,
          ),
        ),
        child: Icon(
          icon,
          size: isCartView ? 10.sp : 16.sp,
          color: buttonColor,
        ),
      ),
    );
  }
}
