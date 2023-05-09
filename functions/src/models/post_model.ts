import { DeliveryOptions, } from "./enums";

export class PostModel {
    postId:string;
    ownerId:string;
    username:string;
    description:string;
    productName:string;
    brand:string;
    variants:string[];
    price: number;
    location:string;
    rating:number;
    images:string[];
    reviewCount: number;
    likesCount: number;
    selectedVariant:string;
    deliveryOptions:DeliveryOptions;
    quantity:number;
    isProductInStock:boolean;
    archived: boolean;
    sellCount: number;
    commentCount: number;
    timestamp: number;
    constructor(
      {postId,ownerId,username,description,productName,brand,variants,price,location,rating,reviewCount,likesCount ,images,selectedVariant,
      deliveryOptions,quantity,isProductInStock,archived,sellCount, commentCount, timestamp}:
      {postId: string,
      ownerId:string,
      username:string,
      description:string,
      productName:string,
      brand:string,
      variants:string[],
      price: number,
      location:string,
      rating:number,
      images:string[],
      likesCount: number,
      reviewCount: number,
      selectedVariant:string,
      deliveryOptions:DeliveryOptions,
      quantity:number,
      isProductInStock:boolean,
      archived: boolean,
      sellCount: number, 
      commentCount: number
      timestamp: number
    }
    ){
      this.postId = postId;
      this.ownerId = ownerId;
      this.username = username;
      this.description = description;
      this.productName = productName;
      this.brand = brand;
      this.variants = variants;
      this.price = price;
      this.location = location;
      this.rating = rating;
      this.images = images;
      this.selectedVariant= selectedVariant;
      this.deliveryOptions = deliveryOptions;
      this.quantity = quantity;
      this.isProductInStock = isProductInStock;
      this.archived = archived;
      this.sellCount = sellCount;
      this.reviewCount = reviewCount;
      this.likesCount = likesCount;
      this.commentCount = commentCount;
      this.timestamp = timestamp;
    }
    get priceInCents():number {return this.price * 100;}
    
    //convert postModel to Map
    toMap() {
      return {
        postId: this.postId,
        ownerId: this.ownerId,
        username: this.username,
        description: this.description,
        productName: this.productName,
        brand: this.brand,
        variants: this.variants,
        price: this.price,
        location: this.location,
        rating: this.rating,
        images: this.images,
        selectedVariant: this.selectedVariant,
        delivery: this.deliveryOptions,
        quantity: this.quantity,
        isProductInStock: this.isProductInStock,
        archived: this.archived,
        sellCount: this.sellCount,
        reviewCount: this.reviewCount,
        likesCount: this.likesCount,
        commentCount: this.commentCount,
        timestamp: this.timestamp,
      };
    }

    toAlgolia() {
      return {
        "postId": this.postId,
        "ownerId": this.ownerId,
        'objectID': this.postId,
        "productName": this.productName,
        "brand": this.brand,
        'username': this.username,
        "price": this.price,
        "description": this.description,
        "location": this.location,
        "archived": this.archived,
        "sellCount": this.sellCount,
        "timestamp": this.timestamp,
      };
    }
}