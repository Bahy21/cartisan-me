enum OrderItemStatus {
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

// convert OrderItemStatus to appropropraite strings using a function
String orderItemStatusToString(OrderItemStatus status) {
  switch (status) {
    case OrderItemStatus.pending:
      return 'Pending';
    case OrderItemStatus.awaitingPayment:
      return 'Awaiting Payment';
    case OrderItemStatus.awaitingFulfillment:
      return 'Awaiting Fulfillment';
    case OrderItemStatus.awaitingShipment:
      return 'Awaiting Shipment';
    case OrderItemStatus.awaitingPickup:
      return 'Awaiting Pickup';
    case OrderItemStatus.shipped:
      return 'Shipped';
    case OrderItemStatus.completed:
      return 'Completed';
    case OrderItemStatus.refunded:
      return 'Refunded';
    case OrderItemStatus.cancelled:
      return 'Cancelled';
    default:
      return 'Unknown';
  }
}
