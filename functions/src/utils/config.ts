import Stripe from "stripe";

export const stripeSecretKey = process.env.STRIPE_SECRET_KEY || "";
export const stripePublishableKey = process.env.STRIPE_PUBLISHABLE_KEY || "";
export const stripeWebhookSecret = process.env.STRIPE_WEBHOOK_SECRET || "";
export const stripeApiVersion= "2020-08-27";
export const stripe = new Stripe(stripeSecretKey, { apiVersion: stripeApiVersion });