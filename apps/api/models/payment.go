package models

import (
	"time"
)

// Payment represents a payment transaction in the system
type Payment struct {
	ID            string    `json:"id" firestore:"id"`
	UserID        string    `json:"user_id" firestore:"user_id"`
	BHubID        string    `json:"bhub_id" firestore:"bhub_id"`
	Amount        float64   `json:"amount" firestore:"amount"`
	PaymentMethod string    `json:"payment_method" firestore:"payment_method"`
	Status        string    `json:"status" firestore:"status"` // pending, completed, refunded, failed
	TransactionID string    `json:"transaction_id,omitempty" firestore:"transaction_id,omitempty"`
	CreatedAt     time.Time `json:"created_at" firestore:"created_at"`
	UpdatedAt     time.Time `json:"updated_at" firestore:"updated_at"`
}

// PaymentRequest represents a request to process a payment
type PaymentRequest struct {
	UserID        string  `json:"user_id" binding:"required"`
	BHubID        string  `json:"bhub_id" binding:"required"`
	Amount        float64 `json:"amount" binding:"required"`
	PaymentMethod string  `json:"payment_method" binding:"required"` // google_pay, vnpay
}

// PaymentResponse represents the response after processing a payment
type PaymentResponse struct {
	PaymentID string `json:"payment_id"`
	Status    string `json:"status"`
}

// RefundRequest represents a request to refund a payment
type RefundRequest struct {
	BHubID string `json:"bhub_id" binding:"required"`
}

// RefundResponse represents the response after processing a refund
type RefundResponse struct {
	Message string `json:"message"`
}