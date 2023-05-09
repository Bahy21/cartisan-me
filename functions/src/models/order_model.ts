import { Address } from "./address";
import { OrderItemStatus } from "./enums";
import { OrderItemModel } from "./order_item_model";

export class OrderModel {
    orderId: string;
    billingAddress: Address;
    shippingAddress: Address;
    buyerId: string;
    orderItems: OrderItemModel[] = [];
    total: number;
    timestamp: number;
    involvedSellersList: string[];
    totalInCents: number;
    orderStatus: OrderItemStatus
    get totalInString(): string {
      return this.total.toFixed(2);
    }
    constructor({orderId,buyerId,orderItems,total,timestamp,involvedSellersList,totalInCents, orderStatus}:
       { orderId: string,
        buyerId: string,
        orderItems: OrderItemModel[],
        total: number,
        timestamp: number,
        involvedSellersList: string[],
        totalInCents: number, 
        orderStatus: OrderItemStatus}
    ) {
        this.orderId = orderId;
        this.buyerId = buyerId;
        this.orderItems = orderItems;
        this.total = total;
        this.timestamp = timestamp;
        this.involvedSellersList = involvedSellersList;
        this.totalInCents = totalInCents;
        this.orderStatus = orderStatus;
    }
    // TODO: ADD ADDRESSES
    toMap(){
        let orderItems = [];
        this.orderItems.forEach((orderItem)=>{
            orderItems.push(orderItem.toMap());
        }); 
        return {
            orderId: this.orderId,
            buyerId: this.buyerId,
            orderItems: orderItems,
            total: this.total,
            timestamp: this.timestamp,
            involvedSellersList: this.involvedSellersList,
            totalInCents: this.totalInCents   
        }
    }
    toString(){
        return JSON.stringify(this.toMap());
    }
    incomplete(){
        return (
            this.orderId == null
            || this.buyerId == null
            || this.orderItems == null
            || this.total == null
            || this.timestamp == null
            || this.involvedSellersList == null
            || this.totalInCents == null
        )
    }
  }