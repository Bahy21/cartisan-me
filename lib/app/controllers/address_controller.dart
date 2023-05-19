import 'package:cartisan/app/api_classes/user_api.dart';
import 'package:cartisan/app/controllers/auth_service.dart';
import 'package:cartisan/app/data/global_functions/error_dialog.dart';
import 'package:cartisan/app/models/address__model.dart';
import 'package:get/get.dart';

class AddressController extends GetxController {
  final userApi = UserAPI();
  List<AddressModel> get addresses => _addresses.value;
  bool get loading => _loading.value;
  AddressModel? get selectedAddress => _selectedAddress.value;
  Rx<AddressModel?> _selectedAddress = Rx<AddressModel?>(null);
  set updatedSelectedAddress(AddressModel value) =>
      _selectedAddress.value = value;
  Rx<List<AddressModel>> _addresses = Rx<List<AddressModel>>([]);
  RxBool _loading = true.obs;
  String get _currentUid => Get.find<AuthService>().currentUser!.uid;
  @override
  void onInit() {
    loadAddresses();
    super.onInit();
  }

  void updateAddress({
    required AddressModel newAddress,
    required int index,
  }) async {
    _loading.value = true;
    final result = await userApi.updateAddress(
      userId: _currentUid,
      address: newAddress,
      addressId: newAddress.addressID,
    );
    if (result) {
      _addresses.value[index] = newAddress;
      _addresses.refresh();
    } else {
      showErrorDialog('Error updating address');
    }
    _loading.value = false;
  }

  void loadAddresses() async {
    _loading.value = true;
    _addresses.value = await userApi.getAllUserAddresses(_currentUid);
    _loading.value = false;
  }

  void newAddress(AddressModel newAddress) async {
    _loading.value = true;
    final result =
        await userApi.addAddress(userId: _currentUid, newAddress: newAddress);
    if (result) {
      _addresses.value.add(newAddress);
      _addresses.refresh();
      Get.back<void>();
    } else {
      showErrorDialog('Error adding address');
    }
    _loading.value = false;
  }
}
