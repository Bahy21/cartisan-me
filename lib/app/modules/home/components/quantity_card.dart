import 'package:cartisan/app/data/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuantityCard extends StatefulWidget {
  final ValueChanged<int> onChanged;
  final bool isCartView;
  const QuantityCard({
    required this.onChanged,
    this.isCartView = false,
    super.key,
  });

  @override
  State<QuantityCard> createState() => _QuantityCardState();
}

class _QuantityCardState extends State<QuantityCard> {
  int quantity = 1;

  void incrementQuantity() {
    setState(() {
      quantity++;
    });
    widget.onChanged(quantity);
  }

  void decrementQuantity() {
    setState(() {
      quantity--;
    });

    widget.onChanged(quantity);
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
        if (!widget.isCartView) SizedBox(height: 13.h) else const SizedBox(),
        Row(
          children: [
            QuantityValueCard(
              onTap: decrementQuantity,
              icon: Icons.remove,
              isCartView: widget.isCartView,
            ),
            SizedBox(width: AppSpacing.thirteenHorizontal),
            Text(
              quantity.toString(),
              style: widget.isCartView
                  ? AppTypography.kMedium14
                  : AppTypography.kMedium16,
            ),
            SizedBox(width: AppSpacing.thirteenHorizontal),
            QuantityValueCard(
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
  final VoidCallback onTap;
  final IconData icon;
  final bool isCartView;
  const QuantityValueCard({
    required this.onTap,
    required this.icon,
    this.isCartView = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: isCartView ? 18.h : 27.h,
        width: isCartView ? 18.0.h : 27.0.h,
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(isCartView ? 100.h : AppSpacing.tenRadius),
          border: Border.all(
            color: AppColors.kWhite,
            width: 1.w,
          ),
        ),
        child: Icon(icon, size: isCartView ? 10.sp : 16.sp),
      ),
    );
  }
}
