import { firestore } from "firebase-admin";
import { PostModel } from "../models/post_model";
import { DeliveryOptions, OrderItemStatus } from "../models/enums";
import { UserModel } from "../models/user_model";
import { Address } from "../models/address";
import { CartItemModel } from "../models/cart_item_model";
import { OrderModel } from "../models/order_model";
import { CommentModel } from "../models/comment_model";
import { DocumentSnapshot } from "firebase-admin/firestore";
import { OrderItemModel } from "../models/order_item_model";


export function postFromDoc(doc:firestore.DocumentSnapshot): PostModel{
    const docData = new PostModel({
      postId: doc.data().postId ?? "",
      ownerId: doc.data().ownerId ?? "",
      username: doc.data().username,
      description: doc.data().description ?? "",
      productName: doc.data().productName ?? "",
      brand: doc.data().brand ?? "",
      variants: doc.data().variants ?? [],
      price: parseFloat(doc.data().price.toString()) ?? 0.0,
      location: doc.data().location ?? "",
      rating: doc.data().rating ?? 0,
      reviewCount: doc.data().reviewCount ?? 0,
      likesCount: doc.data().likesCount ?? 0,
      images: doc.data().images ?? [],
      deliveryOptions: doc.data().delivery == null ? DeliveryOptions.pickup : deliveryOptionFromIndex(doc.data().delivery),
      quantity: doc.data().quantity ?? '0',
      selectedVariant: doc.data().selectedVariant ?? "",
      isProductInStock: doc.data().isProductInStock ?? true,
      archived: doc.data().archived ?? false,
      sellCount: doc.data().sellCount ?? 0,
      commentCount: doc.data().commentCount ?? 0,
      timestamp: doc.data().timestamp ?? 0,
    });
    return docData;
  };

  export function postFromMap(map:Map<any,any>): PostModel{
    const docData = new PostModel({
      postId: map["postId"] ?? map["objectID"]?? "",
      ownerId: map["ownerId"] ?? "",
      username: map["username"] ?? "",
      description: map["description"] ?? "",
      productName: map["productName"] ?? "",
      brand: map["brand"] ?? "",
      variants: map["variants"] ?? [],
      price: map["price"] ?? 0.0,
      location: map["location"] ?? "",
      rating: map["rating"] ?? 0,
      reviewCount: map["reviewCount"] ?? 0,
      likesCount: map["likesCount"] ?? 0,
      images: map["images"] ?? [],
      deliveryOptions: map["delivery"] == null ? DeliveryOptions.pickup : deliveryOptionFromIndex(map["delivery"]),
      quantity: map["quantity"] ?? '0',
      selectedVariant: map["selectedVariant"] ?? "",
      isProductInStock: map["isProductInStock"] ?? true,
      archived: map["archived"] ?? false,
      sellCount: map["sellCount"] ?? 0,
      commentCount: map["commentCount"] ?? 0,
      timestamp: map["timestamp"] ?? 0,
    });
    return docData;
  };

export function userFromDoc(doc:firestore.DocumentSnapshot): UserModel{
  const user = new UserModel(
   { id: doc.data().id,
    username: doc.data().username,
    url : doc.data().url,
    email: doc.data().email}
  );
  user.profileName = doc.data().profileName ?? "";
  user.unreadMessageCount = doc.data().unreadMessageCount ?? 0;
  user.taxPercentage = doc.data().taxPercentage ?? 0;
  user.bio = doc.data().bio ?? "";
  user.shippingCost = doc.data().shippingCost ?? 0;
  user.deliveryCost = doc.data().deliveryCost ?? 0;
  user.freeShipping = doc.data().freeShipping ?? 0;
  user.freeDelivery = doc.data().freeDelivery ?? 0;
  user.activeShipping = doc.data().activeShipping ?? false;
  user.pickup = doc.data().pickup ?? false;
  user.isDeliveryAvailable = doc.data().isDeliveryAvailable ?? false;
  user.sellerID = doc.data().sellerID ?? "";
  user.buyerID = doc.data().buyerID ?? "";
  user.defaultAddress = doc.data().defaultAddress==null ? null : addressFromMap(doc.data().defaultAddress);
  user.country = doc.data().country ?? "";
  user.state = doc.data().state ?? "";
  user.city = doc.data().city ?? "";
  user.isSeller = doc.data().isSeller ?? false;
  user.customerId = doc.data().customerId ?? "";
  user.uniqueStoreName = doc.data().uniqueStoreName ?? "";
  user.followerCount = doc.data().followerCount ?? 0;
  user.followingCount = doc.data().followingCount ?? 0;
  return user;
}


export function cartFromDoc(doc:firestore.DocumentSnapshot) : CartItemModel[]{
  let cartList = <CartItemModel[]>[];
  const data = doc.data().cart;
  if (data==null){
    return null;
  }
  data.forEach((item) => {
    const cartItem = cartItemFromMap(item);
    cartList.push(cartItem);
  });
  return cartList;
}

export function cartListFromMap(map:Map<any,any>) : CartItemModel[]{
  let cart = <CartItemModel[]>[];
  if (map.keys.length == 0){
    return null;
  }
  map.forEach((item) => {
    const cartItem = cartItemFromMap(item);
    cart.push(cartItem);
  });
  return cart;
}

export function cartItemFromMap(map:Map<any,any>): CartItemModel{
  const cartItem = new CartItemModel({
    cartItemId: map['cartItemId'] ?? "",
    postId: map['postId'] ?? "",
    sellerId: map['sellerId'] ?? "",
    username: map['username'] ?? "",
    description: map['description'] ?? "",
    productname: map['productname'] ?? "",
    brand: map['brand'] ?? "",
    price: map['price' ?? 0],
    discount: map['discount'] ?? 0,
    priceInCents: map['priceInCents'] ?? 0,
    discountInCents: map['discountInCents'] ?? 0,
    images: map['images'] ?? <string[]>[],
    selectedVariant: map['selectedVariant'] ?? "",
    quantity: map['quantity'] ?? 0,
    variants: map['variants'] ?? <string[]>[],
    deliveryOptions: DeliveryOptions.delivery,
  });
  return cartItem;
}


export function addressesFromMap(map): Address[]{
  let addresses = <Address[]>[];
  if (map == null){
    return null;
  }
  if (map.keys.length == 0){
    return null;
  }
  map.forEach((value, key) => {
    addresses.push(addressFromMap(value));
  });
  return addresses;
}
export function addressFromMap(map:Map<any,any>): Address{
  if (map==null || map.keys.length == 0){
    return null;
  }
  return new Address({
    userID: map['userID']?? "",
    addressID: map['addressID']?? "",
    addressLine1: map['addressLine1']?? "",
    addressLine2: map['addressLine2']?? "",
    addressLine3: map['addressLine3']?? "",
    postalCode: map['postalCode']?? "",
    contactNumber: map['contactNumber']?? "",
    city: map['city']?? "",
    state: map['state'] ?? "",
    fullname: map['fullname'] ?? ""});
}

export function findItemWithOption(postId: string, selectedVariant:string, cart: CartItemModel[]):number {
  if (cart.length == 0){
    return null;
  }
  const result = cart.findIndex((item) => item.postId == postId && item.selectedVariant == selectedVariant);
  if(result==-1){
    return null;
  }
  return result;
}

export function cartItemFromPost(post:PostModel) : CartItemModel{
  return new CartItemModel({
    //TODO WTF EVEN GOES HERE
    cartItemId: "",
    postId: post.postId,
    sellerId: post.ownerId,
    username: post.username,
    description: post.description,
    productname: post.productName,
    brand: post.brand,
    deliveryOptions: DeliveryOptions.delivery,
    price: post.price,
    discount: 0,
    priceInCents: post.price * 100,
    discountInCents: 0,
    images: post.images,
    quantity: post.quantity,
    selectedVariant: post.selectedVariant,
    variants: post.variants,
  });
}

export function cartItemFromDoc(cartItem: DocumentSnapshot): CartItemModel{
  return new CartItemModel({
    cartItemId: cartItem.data().cartItemId,
    postId: cartItem.data().postId ,
    sellerId: cartItem.data().sellerId ,
    username: cartItem.data().username ,
    description: cartItem.data().description ,
    productname: cartItem.data().productname ,
    brand: cartItem.data().brand ,
    price: cartItem.data().price ,
    discount: cartItem.data().discount ,
    priceInCents: cartItem.data().priceInCents ,
    discountInCents: cartItem.data().discountInCents ,
    images: cartItem.data().images ,
    selectedVariant: cartItem.data().selectedVariant ,
    quantity: cartItem.data().quantity ,
    variants: cartItem.data().variants ,
    deliveryOptions: DeliveryOptions.delivery,
  })
}
// from Map
export function commentFromDoc(doc: DocumentSnapshot){
  return new CommentModel({
      username: doc.data().username?? "",
      userId: doc.data().userId ?? "",
      url: doc.data().url ?? "",
      comment: doc.data().comment ?? "",
      timestamp: doc.data().timestamp ?? Date.now(),
      commentId: doc.data().commentId ?? "",
  })
}

export function orderFromDoc(doc: DocumentSnapshot) : OrderModel{
  return new OrderModel({
    orderId: doc.data().orderId,
    buyerId: doc.data().buyerId,
    orderItems: orderItemsFromList(doc.data().orderItems),
    total: doc.data().total,
    timestamp: doc.data().timestamp,
    involvedSellersList: doc.data().involvedSellersList,
    totalInCents: doc.data().totalInCents,
    orderStatus: doc.data().orderStatus,
  })
}

export function orderItemsFromList(list:Map<any,any>){
  let orderItems = <OrderItemModel[]>[];
  if (list == null || list.keys.length == 0){
    return null;
  }
  list.forEach((value, key) => {
    orderItems.push(orderItemFromMap(value));
  });
  return orderItems;
}

export function orderItemFromMap(map:Map<any,any>): OrderItemModel{
  const orderItem = new OrderItemModel({
    orderItemID: map['orderItemID'],
    productId: map['productId'],
    selectedVariant: map['selectedVariant'],
    appFeeInCents: map['appFeeInCents'],
    quantity: map['quantity'],
    price : map['price'],
    grossTotalInCents: map['grossTotalInCents'],
    sellerId: map['sellerId'],
    deliveryOption : map['deliveryOption'],
    deliveryCostInCents : map['deliveryCostInCents'],
    costBeforeTaxInCents : map['costBeforeTaxInCents'],
    serviceFeeInCents : map['serviceFeeInCents'],
    tax : map['tax'] ?? 0,
    status : map['status'] ?? OrderItemStatus.pending,
  });
  return orderItem;
}


export function orderItemFromCartItem(cartItem: CartItemModel, seller: UserModel): OrderItemModel{
  const app_fee_percent = 0.02;
  const serviceFeeInCents = 100;
  const costBeforeTaxInCents = cartItem.priceInCents * cartItem.quantity;
    const taxApplicable = seller.state && seller.taxPercentage;
    const sellerFeeInCents = costBeforeTaxInCents * app_fee_percent;
    const appFeeInCents = serviceFeeInCents + sellerFeeInCents;
    const taxFactor = taxApplicable ? seller.taxPercentage / 100 : 0;
    const taxAmountInCents = parseInt(`${costBeforeTaxInCents * taxFactor}`);
    const deliveryCostInCents = getDeliveryCostInCents(
      cartItem.deliveryOptions,
      seller,
      costBeforeTaxInCents/100
    );

    const grossTotalInCents =
      costBeforeTaxInCents +
      deliveryCostInCents +
      taxAmountInCents +
      serviceFeeInCents;
  const orderItem = new OrderItemModel({
    orderItemID: "",
    productId: cartItem.postId,
    selectedVariant: cartItem.selectedVariant,
    appFeeInCents: appFeeInCents,
    quantity: cartItem.quantity,
    price : cartItem.price,
    grossTotalInCents: grossTotalInCents,
    sellerId: cartItem.sellerId,
    deliveryOption : cartItem.deliveryOptions,
    deliveryCostInCents : seller.deliveryCostInCents,
    costBeforeTaxInCents : costBeforeTaxInCents,
    serviceFeeInCents : serviceFeeInCents,
    tax : seller.taxPercentage,
    status : OrderItemStatus.pending,
  });
  return orderItem;
}


export function getDeliveryCostInCents(deliveryOptions, user, subtotal) {
  switch (deliveryOptions) {
    case DeliveryOptions.pickup.valueOf():
      return 0;
    case DeliveryOptions.shipping.valueOf():
      if (user.freeShipping < subtotal) {
        return 0;
      }
      return user.shippingCost*100;
    case DeliveryOptions.delivery.valueOf():
      if (user.freeDelivery < subtotal) {
        return 0;
      }
      return user.deliveryCost*100;
    default:
      return 0;
  }
}

export function getOrderItemStatusFromString(status: string): OrderItemStatus {
  switch (status.toLowerCase()) {
    case 'pending':
      return OrderItemStatus.pending;
    case 'awaitingpayment':
      return OrderItemStatus.awaitingPayment;
    case 'awaitingfulfillment':
      return OrderItemStatus.awaitingFulfillment;
    case 'awaitingshipment':
      return OrderItemStatus.awaitingShipment;
    case 'awaitingpickup':
      return OrderItemStatus.awaitingPickup;
    case 'shipped':
      return OrderItemStatus.shipped;
    case 'completed':
      return OrderItemStatus.completed;
    case 'refunded':
      return OrderItemStatus.refunded;
    case 'cancelled':
      return OrderItemStatus.cancelled;
    default:
      return OrderItemStatus.pending;
  }
}

export function deliveryOptionFromIndex(index: number,): DeliveryOptions{
  switch (index) {
    case 0:
      return DeliveryOptions.shipping;
    case 1: 
      return DeliveryOptions.delivery;
    default:
      return DeliveryOptions.pickup;
  }
}


