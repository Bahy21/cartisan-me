import 'dart:convert';

class AddressModel {
  String userID;
  String addressID;
  String addressLine1;
  String addressLine2;
  String addressLine3;
  String postalCode;
  String contactNumber;
  String fullname;
  String city;
  String state;
  AddressModel({
    required this.userID,
    required this.addressID,
    required this.addressLine1,
    required this.addressLine2,
    required this.addressLine3,
    required this.postalCode,
    required this.contactNumber,
    required this.city,
    required this.state,
    required this.fullname,
  });

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      userID: map['userID'] as String,
      addressID: map['addressID'] as String,
      addressLine1: map['addressLine1'] as String,
      addressLine2: map['addressLine2'] as String,
      addressLine3: map['addressLine3'] as String,
      postalCode: map['postalCode'] as String,
      contactNumber: map['contactNumber'] as String,
      city: map['city'] as String,
      state: map['state'] as String,
      fullname: map['fullname'] as String? ?? '',
    );
  }

  factory AddressModel.fromJson(String source) =>
      AddressModel.fromMap(json.decode(source) as Map<String, dynamic>);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userID': userID,
      'addressID': addressID,
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'addressLine3': addressLine3,
      'postalCode': postalCode,
      'contactNumber': contactNumber,
      'city': city,
      'state': state,
      'fullname': fullname,
    };
  }

  String toJson() => json.encode(toMap());
}
