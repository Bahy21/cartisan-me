import { DeliveryOptions, OrderItemStatus } from "./enums";

export class OrderItemModel {
    orderItemID: string;
    productId: string;
    productOption: string;
    appFeeInCents: number;
    quantity: number;
    price: number;
    grossTotalInCents: number;
    sellerId: string;
    deliveryOption: DeliveryOptions;
    deliveryCostInCents: number;
    costBeforeTaxInCents: number;
    serviceFeeInCents: number;
    sellerStripeId: string;
    status: OrderItemStatus;
    tax: number;
    currency: string;
    state: string;
  
  


    constructor({
      orderItemID,
      productId,
      productOption,
      appFeeInCents,
      quantity,
      price,
      grossTotalInCents,
      sellerId,
      deliveryOption,
      deliveryCostInCents,
      costBeforeTaxInCents,
      serviceFeeInCents,
      tax,
      status,
      currency,
      state,
    }:{
      orderItemID: string;
      productId: string;
      productOption: string;
      appFeeInCents: number;
      quantity: number;
      price: number;
      grossTotalInCents: number;
      sellerId: string;
      deliveryOption: DeliveryOptions;
      deliveryCostInCents: number;
      costBeforeTaxInCents: number;
      serviceFeeInCents: number;
      tax: number;
      status: OrderItemStatus;
      currency: string;
      state: string;
    }) {
      this.productOption = productOption;
      this.orderItemID = orderItemID;
      this.productId = productId;
      this.appFeeInCents = appFeeInCents;
      this.quantity = quantity;
      this.price = price;
      this.grossTotalInCents = grossTotalInCents;
      this.sellerId = sellerId;
      this.deliveryOption = deliveryOption;
      this.deliveryCostInCents = deliveryCostInCents;
      this.costBeforeTaxInCents = costBeforeTaxInCents;
      this.serviceFeeInCents = serviceFeeInCents;
      this.tax = tax;
      this.status = status;
      this.currency = currency;
      this.state = state;

    }
  
    get grossTotal(): number {
      return this.grossTotalInCents / 100;
    }
  
    get grossTotalString(): string {
      return (this.grossTotalInCents / 100).toFixed(2);
    }
  
    get deliveryCost(): number {
      return this.deliveryCostInCents / 100;
    }
  
    get deliveryCostString(): string {
      return (this.deliveryCostInCents / 100).toFixed(2);
    }
  
    get costBeforeTax(): number {
      return this.costBeforeTaxInCents / 100;
    }

    toMap(){
        return {
          productOption: this.productOption,
            orderItemID: this.orderItemID,
            productId: this.productId,
            appFeeInCents: this.appFeeInCents,
            quantity: this.quantity,
            price: this.price,
            grossTotalInCents: this.grossTotalInCents,
            sellerId: this.sellerId,
            deliveryOption: this.deliveryOption,
            deliveryCostInCents: this.deliveryCostInCents,
            costBeforeTaxInCents: this.costBeforeTaxInCents,
            serviceFeeInCents: this.serviceFeeInCents,
            sellerStripeId: this.sellerStripeId ?? this.sellerId,
            tax: this.tax,
            status: this.status.valueOf(),
            
        }
    }

    incomplete(){
      return (
        this.productOption == null ||
        this.orderItemID == null ||
        this.productId == null ||
        this.appFeeInCents == null ||
        this.quantity == null ||
        this.price == null ||
        this.grossTotalInCents == null ||
        this.sellerId == null ||
        this.deliveryOption == null ||
        this.deliveryCostInCents == null ||
        this.costBeforeTaxInCents == null ||
        this.serviceFeeInCents == null ||
        this.sellerStripeId == null ||
        this.tax == null ||
        this.status == null
      )
    }

    toString(){
      return JSON.stringify(this.toMap());
    }
  }  