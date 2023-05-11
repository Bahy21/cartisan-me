class NotificationController extends GetXController{
  Rx<List<NotificationModel>> _notifications = Rx<List<NotificationModel>>(<NotificationModel>[]);
  List<NotificationModel> get notifications => _notifications.value;


  Rxbool _isLoading = true.obs;
  bool get isLoading => _isLoading.value;
  RxInt _totalNotificationsLoaded = 0.obs;
  int get totalNotificationsLoaded => _totalPostsLoaded.value;
  Rxbool _isNotifcationsLoading = false.obs;
  bool get isNotifcationsLoading => _isNotifcationsLoading.value;

  String get _currentUid => FirebaseAuth.instance.currentUser!.uid;


  Future<void> fetchNotifications({bool isRefresh = false}) async {
    _isNotifcationsLoading.value = true;
    if(isRefresh) {
      _isLoading.value = true;
    }
    List<NotificationModel> newPosts = <NotificationModel>[];
    log('fetching posts on init');
    String? lastId;
    if(timelinePosts.value.length.isNotEmpty && !isRefresh){
      lastId = timelinePosts.value.last.postId;s
    }
    final results = dio.get(apiCalls.getApiCalls.getNotifications(_currentUid), data:{'lastNotificationId': lastNotificationId});
    if (results.isEmpty){
      _isNotifcationsLoading.value = false;
      _isLoading.value = false;
      return;
    }
    _totalNotificationsLoaded.value = isRefresh
        ? results.length
        : _totalNotificationsLoaded.value + results.length;
    for(final post in results){
      newPosts.add(NotificationModels.fromMap(post.data() as Map<String, dynamic>));
    }
    _notifications.value = [...notifications,...newPosts];
    _isNotifcationsLoading.value = false;
    _isLoading.value = false;
  }
}