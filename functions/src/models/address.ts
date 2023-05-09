export class Address {
  userID:string;
  addressID:string;
  addressLine1:string;
  addressLine2:string;
  addressLine3:string;
  postalCode:string;
  contactNumber:string;
  fullname:string;
  city:string;
  state:string;
  constructor(
    {userID, addressID, addressLine1, addressLine2, addressLine3, postalCode,
    contactNumber, city, state, fullname,}: {userID:string;
      addressID:string;
      addressLine1:string;
      addressLine2:string;
      addressLine3:string;
      postalCode:string;
      contactNumber:string;
      fullname:string;
      city:string;
      state:string;}
  ){
    this.userID = userID;
    this.addressID = addressID;
    this.addressLine1 = addressLine1;
    this.addressLine2 = addressLine2;
    this.addressLine3 = addressLine3;
    this.postalCode = postalCode;
    this.contactNumber = contactNumber;
    this.city = city;
    this.state =state;
    this.fullname = fullname;
  }

  toMap() {
    return {
      userID: this.userID,
      addressID: this.addressID,
      addressLine1: this.addressLine1,
      addressLine2: this.addressLine2,
      addressLine3: this.addressLine3,
      postalCode: this.postalCode,
      contactNumber: this.contactNumber,
      city: this.city,
      state: this.state,
      fullname: this.fullname,
    };
  }
}