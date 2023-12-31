import 'package:cartisan/app/data/constants/constants.dart';
import 'package:cartisan/app/models/post_model.dart';
import 'package:cartisan/app/modules/home/components/custom_drop_down.dart';
import 'package:cartisan/app/modules/home/components/expandable_text.dart';
import 'package:cartisan/app/modules/home/components/post_card.dart';
import 'package:cartisan/app/modules/home/components/quantity_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class UserOwnPostCard extends StatelessWidget {
  final PostModel post;
  const UserOwnPostCard({
    required this.post,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      padding: EdgeInsets.only(
        left: 9.w,
        right: AppSpacing.eightHorizontal,
        top: AppSpacing.twelveVertical,
        bottom: AppSpacing.seventeenVertical,
      ),
      decoration: BoxDecoration(
        color: AppColors.kGrey,
        borderRadius: BorderRadius.circular(AppSpacing.sixRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 13.h),
          PostImageCarousel(images: post.images),
          SizedBox(height: AppSpacing.seventeenVertical),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                post.productName,
                style: AppTypography.kBold18,
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.kPrimary,
                  padding: EdgeInsets.all(13.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.sixRadius),
                  ),
                ),
                child: Text(
                  'Priced at | ${post.price}',
                  style: AppTypography.kBold14,
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Text('Description:', style: AppTypography.kBold14),
          SizedBox(height: 11.h),
          ExpandableText(text: post.description),
          SizedBox(height: 14.h),
          Row(
            children: [
              Expanded(
                flex: 6,
                child: QuantityCard(
                  quantity: post.quantity,
                  onChanged: (quantity) {
                    post.quantity = quantity;
                  },
                ),
              ),
              Expanded(
                flex: 4,
                child: CustomDropDown(
                  defaultValue: post.variants.first,
                  items: post.variants,
                  onChanged: (value) {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
