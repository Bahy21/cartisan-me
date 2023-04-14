import 'package:cartisan/app/data/constants/constants.dart';
import 'package:cartisan/app/modules/sidemenu/orders/purchased_order.dart';
import 'package:cartisan/app/modules/sidemenu/orders/sold_orders.dart';
import 'package:flutter/material.dart';

class AllOrders extends StatelessWidget {
  const AllOrders({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('All Orders', style: AppTypography.kLight18),
          bottom: TabBar(
            indicatorColor: AppColors.kBlue,
            labelStyle: AppTypography.kBold14,
            unselectedLabelStyle:
                AppTypography.kBold14.copyWith(color: AppColors.kHintColor),
            tabs: const [
              Tab(text: 'Purchased'),
              Tab(text: 'Sold'),
            ],
          ),
        ),
        body: const TabBarView(children: [
          PurchasedOrder(),
          SoldOrders(),
        ]),
      ),
    );
  }
}
