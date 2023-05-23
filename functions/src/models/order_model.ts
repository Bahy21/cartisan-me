import { Address } from "./address";
import { OrderItemStatus } from "./enums";
import { OrderItemModel } from "./order_item_model";

export class OrderModel {
    orderId: string;
    address: Address;
    shippingAddress: Address;
    buyerId: string;
    orderItems: OrderItemModel[];
    total: number;
    timestamp: number;
    involvedSellersList: string[];
    totalInCents: number;
    orderStatus: OrderItemStatus  
    currency: string;
    isPaid: boolean;



    get totalInString(): string {
      return this.total.toFixed(2);
    }
    constructor({orderId,buyerId,orderItems,total,timestamp,involvedSellersList,totalInCents, orderStatus, address, shippingAddress, currency, isPaid}:
       { orderId: string,
        buyerId: string,
        orderItems: OrderItemModel[],
        total: number,
        timestamp: number,
        involvedSellersList: string[],
        totalInCents: number, 
        orderStatus: OrderItemStatus,
        address: Address,
        shippingAddress: Address,
        currency: string,
        isPaid: boolean}
    ) {
        this.orderId = orderId;
        this.buyerId = buyerId;
        this.orderItems = orderItems;
        this.total = total;
        this.timestamp = timestamp;
        this.involvedSellersList = involvedSellersList;
        this.totalInCents = totalInCents;
        this.orderStatus = orderStatus;
        this.address = address;
        this.shippingAddress = shippingAddress;
        this.currency = currency;
        this.isPaid = isPaid;
    }
    // TODO: ADD ADDRESSES
    toMap(){
        let orderItems = [];
        let sellers = <string[]>[]
        for(const orderItem of this.orderItems){
            orderItems.push(orderItem.toMap());
            sellers.push(orderItem.sellerId);
        }; 
        return {
            orderId: this.orderId,
            buyerId: this.buyerId,
            orderItems: orderItems,
            total: this.total,
            timestamp: this.timestamp,
            involvedSellersList: this.involvedSellersList,
            totalInCents: this.totalInCents,
            orderStatus: this.orderStatus,
            address: this.address.toMap(),
            shippingAddress: this.shippingAddress.toMap(),
            currency: this.currency,
            isPaid: this.isPaid,
            sellers:sellers,
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