import 'package:cartisan/app/models/post_model.dart';
import 'package:cartisan/app/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:social_share/social_share.dart';

Future<void> shareUser(UserModel user) async {
  await Get.bottomSheet<Widget>(
    bottomSheet(
      'https://www.cartisan.shop/store/${user.id}',
      user.url,
      isStore: true,
    ),
  );
}

Future<void> shareProduct(PostModel postModel) async {
  await Get.bottomSheet<Widget>(
    bottomSheet(
      'https://www.cartisan.shop/product/${postModel.postId}',
      postModel.images.first,
    ),
  );
}

Widget bottomSheet(String urlToShare, String imagePath,
    {bool isStore = false}) {
  return Material(
    child: ListView(
      children: [
        buildTile(
          FontAwesomeIcons.link,
          'Share URL',
          () async {
            await SocialShare.copyToClipboard(
              text: urlToShare,
            );
            Get.snackbar('Copied', 'Link copied to clipboard',
                barBlur: 1,
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.white);
          },
        ),
        buildTile(
          FontAwesomeIcons.commentSms,
          'Share via sms',
          () => SocialShare.shareSms(
            "Hey! Check out my ${isStore ? 'store' : 'product'} on Cartisan " +
                urlToShare,
          ),
        ),
        buildTile(
          FontAwesomeIcons.telegram,
          'Share on Telegram',
          () => SocialShare.shareTelegram(
            "Hey! Check out my ${isStore ? 'shop' : 'product'} on Cartisan " +
                urlToShare,
          ),
        ),
        buildTile(
          FontAwesomeIcons.twitter,
          'Share via Twitter',
          () => SocialShare.shareTwitter(
            "Hey! Check out my ${isStore ? 'store' : 'product'} on Cartisan " +
                urlToShare,
            hashtags: ['Cartisan', 'MyShop', 'MyProduct'],
            url: urlToShare,
          ),
        ),
        buildTile(
          FontAwesomeIcons.whatsapp,
          'Share via Whatsapp',
          () => SocialShare.shareWhatsapp(
            "Hey! Check out my ${isStore ? 'store' : 'product'} on Cartisan " +
                urlToShare,
          ),
        ),
      ],
    ),
  );
}

Widget buildTile(IconData icon, String title, Function() onTap) {
  return ListTile(
    onTap: () {
      onTap();
      Get.back<void>();
    },
    trailing: Icon(icon),
    title: Text(
      title,
      style: TextStyle(fontWeight: FontWeight.w500),
    ),
  );
}
