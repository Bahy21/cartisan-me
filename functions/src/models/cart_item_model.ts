import { DeliveryOptions } from "./enums";

export class CartItemModel {
  cartItemId: string;
  postId: string;
  sellerId: string;
  username: string;
  description: string;
  productname: string;
  brand: string;
  deliveryOptions: DeliveryOptions;
  /// price in USD
  price: number;
  discount: number;
  /// pirce in Cents
  priceInCents: number;
  discountInCents: number;
  images: string[];
  variants: string[];
  selectedVariant: string;
  quantity: number;
  constructor({cartItemId: itemId, postId, sellerId: ownerId, username, description, 
    productname, brand, deliveryOptions, price, discount, 
    priceInCents, discountInCents, images, variants, 
    selectedVariant, quantity}:{
      cartItemId:string,
      postId:string,
      sellerId:string,
      username:string,
      description:string,
      productname:string,
      brand:string,
      deliveryOptions:DeliveryOptions,
      price:number,
      discount:number,
      priceInCents:number,
      discountInCents:number,
      images:string[],
      variants:string[],
      selectedVariant:string,
      quantity:number,}){
      this.cartItemId = itemId;
      this.postId = postId;
      this.sellerId = ownerId;
      this.username = username;
      this.description = description;
      this.productname = productname;
      this.brand = brand;
      this.deliveryOptions = deliveryOptions;
      this.price = price;
      this.discount = discount;
      this.priceInCents = priceInCents;
      this.discountInCents = discountInCents;
      this.images = images;
      this.variants = variants;
      this.selectedVariant = selectedVariant;
      this.quantity = quantity;
  }

  toMap() {
    return {
      cartItemId: this.cartItemId,
      postId: this.postId,
      sellerId: this.sellerId,
      username: this.username,
      description: this.description,
      productname: this.productname,
      brand: this.brand,
      price: this.price,
      discount: this.discount,
      priceInCents: this.priceInCents,
      discountInCents: this.discountInCents,
      images: this.images,
      selectedVariant: this.selectedVariant,
      quantity: this.quantity,
      variants: this.variants,
      deliveryOptions: this.deliveryOptions != null ? this.deliveryOptions.valueOf() : null,
    };
  }
  //convert this class into a string
  toString(): string {
    return JSON.stringify(this.toMap());
  }
  incomplete(): boolean{
    return (this.cartItemId == null 
      || this.postId == null 
      || this.sellerId == null 
      || this.username == null 
      || this.description == null
      || this.productname == null
      || this.brand == null
      || this.price == null
      || this.discount == null
      || this.priceInCents == null
      || this.discountInCents == null
      || this.images == null
      || this.selectedVariant == null
      || this.quantity == null
      || this.variants == null
      || this.deliveryOptions == null
    )
  }

}