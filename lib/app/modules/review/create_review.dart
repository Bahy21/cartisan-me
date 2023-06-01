import 'dart:developer';

import 'package:cartisan/app/controllers/purchase_detail_controller.dart';
import 'package:cartisan/app/controllers/user_controller.dart';
import 'package:cartisan/app/data/constants/app_spacing.dart';
import 'package:cartisan/app/models/order_item_model.dart';
import 'package:cartisan/app/models/post_model.dart';
import 'package:cartisan/app/models/review_model.dart';
import 'package:cartisan/app/modules/profile/components/custom_textformfield.dart';
import 'package:cartisan/app/modules/widgets/buttons/primary_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateReview extends StatefulWidget {
  final String orderId;
  final OrderItemModel orderItem;
  final PostModel post;
  const CreateReview({
    required this.orderId,
    required this.orderItem,
    required this.post,
    super.key,
  });

  @override
  State<CreateReview> createState() => _CreateReviewState();
}

class _CreateReviewState extends State<CreateReview> {
  double rating = 0;
  final _reviewText = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final user = Get.find<UserController>().currentUser!;
  PurchaseDetailController pdc = Get.find<PurchaseDetailController>();
  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {
        setState(() {
          rating = 0;
        });
      },
      builder: (context) => Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: AppSpacing.eighteenHorizontal),
            child: Column(
              children: [
                SizedBox(
                  height: AppSpacing.twentyVertical,
                ),
                RatingBar.builder(
                  minRating: 1,
                  allowHalfRating: true,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (newRating) {
                    rating = newRating;
                  },
                ),
                SizedBox(
                  height: AppSpacing.eighteenHorizontal,
                ),
                CustomTextFormField(
                  maxLines: 3,
                  hintText: 'Enter review',
                  controller: _reviewText,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter review';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: AppSpacing.eighteenHorizontal,
                ),
                PrimaryButton(
                  onTap: () {
                    if (rating >= 1 && _formKey.currentState!.validate()) {
                      pdc.createReview(
                        postId: widget.orderItem.productId,
                        review: ReviewModel(
                          reviewID: '',
                          reviewText: _reviewText.text,
                          rating: rating,
                          reviewerName: user.username,
                          reviewerId: user.id,
                          timestamp: DateTime.now().millisecondsSinceEpoch,
                        ),
                      );
                    }
                  },
                  text: 'Post Review',
                ),
                SizedBox(
                  height: AppSpacing.eighteenHorizontal,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
