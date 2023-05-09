export enum OrderItemStatus {
  pending,
  awaitingPayment,
  awaitingFulfillment,
  awaitingShipment,
  awaitingPickup,
  shipped,
  completed,
  refunded,
  cancelled,
}

export enum NotificationType{
  like,
  comment,
  follow,
  order
} 
export enum DeliveryOptions { shipping, delivery, pickup }

export enum InStock { no, yes }

export enum IsArchived { no, yes }
