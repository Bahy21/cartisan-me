import 'package:cartisan/app/api_classes/api_service.dart';
import 'package:cartisan/app/api_classes/cart_api.dart';
import 'package:cartisan/app/api_classes/notifications_api.dart';
import 'package:cartisan/app/api_classes/order_api.dart';
import 'package:cartisan/app/api_classes/payment_api.dart';
import 'package:cartisan/app/api_classes/post_api.dart';
import 'package:cartisan/app/api_classes/report_api.dart';
import 'package:cartisan/app/api_classes/timeline_api.dart';
import 'package:cartisan/app/api_classes/user_api.dart';
import 'package:cartisan/app/controllers/auth_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks(
  [
    MockSpec<APIService>(),
    MockSpec<AuthService>(),
    MockSpec<PostAPI>(),
    MockSpec<CartAPI>(),
    MockSpec<NotificationsAPI>(),
    MockSpec<OrderAPI>(),
    MockSpec<PaymentAPI>(),
    MockSpec<ReportAPI>(),
    MockSpec<TimelineAPI>(),
    MockSpec<UserAPI>(),
  ],
)
void main() {}
