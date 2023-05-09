import {Address} from "./address.js";
export class UserModel{
    id: string;
    username: string;
    url: string;
    email: string;
    profileName: string;
    bio: string;
    unreadMessageCount: number;
    taxPercentage: number;
    shippingCost: number
    deliveryCost: number;
    get deliveryCostInCents(){return Math.floor(this.deliveryCost * 100)};
    freeShipping: number;
    freeDelivery: number;
    activeShipping: boolean;
    pickup: boolean;
    isDeliveryAvailable: boolean;
    sellerID: string ;
    buyerID: string;
    defaultAddress: Address;
    country: string;
    state: string;
    city: string;
    isSeller: boolean;
    customerId: string;
    uniqueStoreName: string;
    followerCount: number;
    followingCount: number;
    constructor(
      {id, username, url, email}: {id: string,
      username: string,
      url: string,
      email: string,}
      ){
        this.id = id;
        this.username = username;
        this.url = url;
        this.email = email;
    }
    toMap(){
      return {
        id: this.id,
        username: this.username,
        url: this.url,
        email: this.email,
        profileName : typeof this.profileName === 'undefined'? '': this.profileName,
        unreadMessageCount: typeof this.unreadMessageCount === 'undefined' ?0:this.unreadMessageCount,
        taxPercentage: typeof this.taxPercentage === 'undefined' ? 0: this.taxPercentage,
        bio: typeof this.bio === 'undefined' ? '': this.bio,
        shippingCost: typeof this.shippingCost === 'undefined' ? 0: this.shippingCost,
        deliveryCost: typeof this.deliveryCost === 'undefined' ? 0: this.deliveryCost,
        freeShipping: typeof this.freeShipping === 'undefined' ? 0: this.freeShipping,
        freeDelivery: typeof this.freeDelivery === 'undefined' ? 0: this.freeDelivery,
        activeShipping: typeof this.activeShipping === 'undefined' ? false : this.activeShipping,
        pickup: typeof this.pickup === 'undefined' ? false : this.pickup,
        isDeliveryAvailable: typeof this.isDeliveryAvailable === 'undefined' ? false : this.isDeliveryAvailable,
        sellerID: typeof this.sellerID === 'undefined' ? '': this.sellerID,
        buyerID: typeof this.buyerID === 'undefined' ? '': this.buyerID,
         defaultAddress: typeof this.defaultAddress === "undefined" || this.defaultAddress == null ? null : this.defaultAddress.toMap(),
        country: typeof this.country === 'undefined' ? '': this.country,
        state: typeof this.state === 'undefined' ? '': this.state,
        city: typeof this.city === 'undefined' ? '': this.city,
        isSeller: typeof this.isSeller === 'undefined' ? false : this.isSeller,
        customerId: typeof this.customerId === 'undefined' ? '': this.customerId,
        uniqueStoreName: typeof this.uniqueStoreName === 'undefined' ? '': this.uniqueStoreName,
        followerCount: typeof this.followerCount === 'undefined' ? 0 : this.followerCount,
        followingCount: typeof this.followingCount === 'undefined' ? 0 : this.followingCount,
      }
    }

  }


  