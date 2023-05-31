// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cartisan/app/data/constants/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:social_share/social_share.dart';

import 'package:cartisan/app/models/post_model.dart';
import 'package:cartisan/app/models/user_model.dart';

Future<void> shareUser(UserModel user) async {
  await Get.bottomSheet<Widget>(
    ShareBottomSheet(
      urlToShare: 'http://open.cartisan.shop/store/${user.id}',
      imagePath: user.url,
      isStore: true,
    ),
  );
}

Future<void> shareProduct(PostModel postModel) async {
  await Get.bottomSheet<Widget>(
    ShareBottomSheet(
      urlToShare: 'http://open.cartisan.shop/post/${postModel.postId}',
      imagePath: postModel.images.first,
    ),
  );
}

class ShareBottomSheet extends StatelessWidget {
  final String urlToShare;
  final String imagePath;
  final bool isStore;
  const ShareBottomSheet({
    required this.urlToShare,
    required this.imagePath,
    this.isStore = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      builder: (context) => ListView(
        children: [
          ShareTile(
            icon: FontAwesomeIcons.link,
            title: 'Share URL',
            onTap: () async {
              await SocialShare.copyToClipboard(
                text: urlToShare,
              );
              Get.snackbar(
                'Copied',
                'Link copied to clipboard',
                barBlur: 1,
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.white,
              );
            },
          ),
          ShareTile(
            icon: FontAwesomeIcons.commentSms,
            title: 'Share via sms',
            onTap: () => SocialShare.shareSms(
              "Hey! Check out my ${isStore ? 'store' : 'product'} on Cartisan $urlToShare",
            ),
          ),
          ShareTile(
            icon: FontAwesomeIcons.telegram,
            title: 'Share on Telegram',
            onTap: () => SocialShare.shareTelegram(
              "Hey! Check out my ${isStore ? 'shop' : 'product'} on Cartisan $urlToShare",
            ),
          ),
          ShareTile(
            icon: FontAwesomeIcons.twitter,
            title: 'Share via Twitter',
            onTap: () => SocialShare.shareTwitter(
              "Hey! Check out my ${isStore ? 'store' : 'product'} on Cartisan $urlToShare",
              hashtags: ['Cartisan', 'MyShop', 'MyProduct'],
              url: urlToShare,
            ),
          ),
          ShareTile(
            icon: FontAwesomeIcons.whatsapp,
            title: 'Share via Whatsapp',
            onTap: () => SocialShare.shareWhatsapp(
              "Hey! Check out my ${isStore ? 'store' : 'product'} on Cartisan $urlToShare",
            ),
          ),
        ],
      ),
    );
  }
}

class ShareTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Function() onTap;
  const ShareTile({
    required this.icon,
    required this.title,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onTap();
        Get.back<void>();
      },
      trailing: Icon(icon),
      title: Text(
        title,
        style: AppTypography.kMedium14,
      ),
    );
  }
}
