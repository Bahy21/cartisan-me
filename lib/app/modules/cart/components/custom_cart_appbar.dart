import 'package:cartisan/app/data/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomCartAppbar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback leadingCallback;
  const CustomCartAppbar({
    required this.leadingCallback,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leadingWidth: 64.w,
      leading: IconButton(
        onPressed: leadingCallback,
        icon: const Icon(Icons.arrow_back),
      ),
      centerTitle: true,
      title: Text(
        'CARTISAN',
        style: TextStyle(
          fontFamily: 'aero_regular',
          fontSize: 22.sp,
          color: Colors.white,
          letterSpacing: 1,
        ),
      ),
      actions: [
        SizedBox(width: AppSpacing.fourteenHorizontal),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class AddressAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback leadingCallback;
  final VoidCallback changeAddressCallback;
  const AddressAppBar({
    required this.leadingCallback,
    required this.changeAddressCallback,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: leadingCallback,
        icon: const Icon(Icons.arrow_back),
      ),
      title: Text(
        'Address',
        style: AppTypography.kLight18,
      ),
      actions: [
        Padding(
          padding: EdgeInsets.all(8.h),
          child: ElevatedButton(
            onPressed: changeAddressCallback,
            child: Text(
              'Add New Address',
              style: AppTypography.kMedium12,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class PaymentAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback leadingCallback;
  const PaymentAppBar({
    required this.leadingCallback,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: leadingCallback,
        icon: const Icon(Icons.arrow_back),
      ),
      title: Text(
        'Add Payment Information',
        style: AppTypography.kLight18,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
