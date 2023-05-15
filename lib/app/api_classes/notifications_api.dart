import 'package:cartisan/app/api_classes/api_service.dart';

String getNotifications(String userId) =>
    '$BASE_URL/notifications/getNotifications/$userId';

class NotificationAPI {
  final apiService = APIService();
}
