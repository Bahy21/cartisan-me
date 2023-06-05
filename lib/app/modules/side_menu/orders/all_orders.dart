import 'package:cartisan/app/controllers/purchase_history_controller.dart';
import 'package:cartisan/app/controllers/sales_history_controller.dart';
import 'package:cartisan/app/data/constants/constants.dart';
import 'package:cartisan/app/modules/side_menu/orders/purchased_order.dart';
import 'package:cartisan/app/modules/side_menu/orders/sold_orders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllOrders extends StatefulWidget {
  const AllOrders({super.key});

  @override
  State<AllOrders> createState() => _AllOrdersState();
}

class _AllOrdersState extends State<AllOrders> {
  @override
  void initState() {
    Get
      ..put(PurchaseHistoryController())
      ..put(SalesHistoryController());
    super.initState();
  }

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
        body: const TabBarView(
          children: [
            PurchasedOrder(),
            SoldOrders(),
          ],
        ),
      ),
    );
  }
}
