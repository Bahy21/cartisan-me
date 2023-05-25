// ignore_for_file: avoid_catches_without_on_clauses

import 'dart:developer';

import 'package:cartisan/app/controllers/controllers.dart';
import 'package:cartisan/app/modules/profile/components/stripe_webview.dart';
import 'package:cartisan/app/services/stripe_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

class StripeSection extends StatelessWidget {
  final uc = Get.find<UserController>();

  StripeSection({super.key});

  Future<void> addStripeSeller(String? sellerID) async {
    try {
      if (sellerID?.isNotEmpty ?? false) {
        final url = await StripeHandler().getDashboardLink(sellerID!);

        if (await canLaunchUrlString(url)) {
          await launchUrlString(url);
        } else {
          log('Could not launch $url');
        }
      } else {
        final value = await Get.bottomSheet<bool>(
          Material(
            child: SizedBox(
              height: 200,
              child: Column(
                children: [
                  ListTile(
                    onTap: () {
                      Get.back<bool>(result: true);
                    },
                    leading: const Icon(Icons.person),
                    title: const Text('Individual'),
                  ),
                  ListTile(
                    onTap: () {
                      Get.back<bool>(result: false);
                    },
                    leading: const Icon(Icons.home_work_outlined),
                    title: const Text('Corporation'),
                  ),
                ],
              ),
            ),
          ),
        );
        if (value == null) return;

        final url =
            await StripeHandler().getSellerUrl(uc.currentUser!.email, value);
        await Get.to<void>(StripeWebview(
          url: url,
        ));
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> _onDelete(String? sellerID) async {
    final result = await Get.dialog<bool>(AlertDialog(
      backgroundColor: Colors.white,
      content: const Text(
        'Are you sure you want to delete your stripe account?',
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      actions: [
        TextButton(
          child: const Text(
            'Cancel',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          onPressed: () {
            Get.back<bool>();
          },
        ),
        TextButton(
          child: const Text(
            'Delete',
            style: TextStyle(
              color: Colors.red,
            ),
          ),
          onPressed: () {
            StripeHandler().deleteConnectAccount(
              uc.currentUser!.id,
              sellerID!,
            );
            Get.back<bool>();
          },
        ),
      ],
    ));
    if (result != true) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: uc.stripeAccountStream(),
      builder: (context, stripeSnapshot) {
        final hasStripe =
            stripeSnapshot.data != null && stripeSnapshot.data!.isNotEmpty;
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => addStripeSeller(stripeSnapshot.data),
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      8.0,
                    ),
                  ),
                ),
                padding: MaterialStateProperty.all<EdgeInsets>(
                  const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                ),
                backgroundColor: MaterialStateProperty.all<Color>(
                  const Color(0xff5433FF),
                ),
              ),
              child: Text(
                hasStripe ? 'View Stripe Dashboard' : 'Connect Stripe',
                style: const TextStyle(color: Colors.white, fontSize: 16.0),
              ),
            ),
            if (hasStripe)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                ),
                child: TextButton(
                  onPressed: () => _onDelete(stripeSnapshot.data),
                  child: const Text(
                    'Delete Stripe',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
