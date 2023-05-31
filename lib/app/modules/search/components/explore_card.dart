import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cartisan/app/data/constants/constants.dart';
import 'package:cartisan/app/models/search_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExploreCard extends StatelessWidget {
  final SearchModel post;
  final VoidCallback? onTap;
  const ExploreCard({
    required this.post,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: CachedNetworkImage(
        imageUrl: post.imageUrl,
        errorWidget: (context, url, dynamic error) {
          log(error.toString());
          return const Icon(
            Icons.error,
          );
        },
        fit: BoxFit.cover,
      ),
    );
  }
}
