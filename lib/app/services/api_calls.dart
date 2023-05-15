class ApiCalls {
  GetApiCalls getApiCalls = GetApiCalls();
  PostApiCalls postApiCalls = PostApiCalls();
  PutApiCalls putApiCalls = PutApiCalls();
  DeleteApiCalls deleteApiCalls = DeleteApiCalls();
}

class GetApiCalls {
  String getNotifications(String userId) =>
      '$BASE_URL/notifications/getNotifications/$userId';
}

class PostApiCalls {}

class PutApiCalls {}

class DeleteApiCalls {}
