import 'package:cartisan/app/data/constants/app_colors.dart';
import 'package:cartisan/app/data/constants/app_spacing.dart';
import 'package:cartisan/app/data/constants/app_typography.dart';
import 'package:cartisan/app/models/review_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReviewCard extends StatelessWidget {
  final ReviewModel review;
  const ReviewCard({required this.review, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColors.kGrey,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RatingBarIndicator(
            rating: review.rating,
            itemBuilder: (context, rating) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
          ),
          SizedBox(height: AppSpacing.eightVertical),
          Text(
            '${review.reviewerName} says:',
            style: AppTypography.kBold20.copyWith(color: AppColors.kPrimary),
          ),
          SizedBox(height: AppSpacing.twelveVertical),
          Text(
            review.reviewText,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.kMedium14,
          ),
        ],
      ),
    );
  }
}
