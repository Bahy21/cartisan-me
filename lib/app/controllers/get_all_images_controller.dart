

// class GetAllImagesController extends GetxController {
//   List<AssetEntity> get paths => _paths.value;
//   bool get loading => _loading.value;
//   Rx<List<AssetEntity>> _paths = Rx<List<AssetEntity>>([]);
//   RxBool _loading = true.obs;
//   @override
//   void onInit() {
//     loadImages();
//     super.onInit();
//   }

//   void loadImages() async {
//     final PermissionState state = await PhotoManager.requestPermissionExtend();
//     if (state != PermissionState.authorized) {
//       return;
//     }
//     final result = await PhotoManager.getAssetPathList(
//       type: RequestType.image,
//     );
//     _paths.value = await result.first.getAssetListPaged(
//       page: 0,
//       size: 20,
//     );
//     _loading.value = false;
//   }
// }
