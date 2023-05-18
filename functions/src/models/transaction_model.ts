export interface Transaction {
    id: string;
    orderId: string;
    buyerId: string;
    chargeId?: string;
    amountInCents: number;
    status: TransactionStatus;
    receiptUrl?: string;
    createdAt: number;
    paymentMethod: string;
    currency: string;
    transfers?: any[];
    paymentDetail: any;
  }
  export enum TransactionStatus {
    PENDING,
    SUCCESS,
    FAILED,
    REFUNDED,
  }
  