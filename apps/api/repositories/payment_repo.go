package repositories

import (
	"context"
	"time"

	"cloud.google.com/go/firestore"
	"github.com/ducnmm/bhub/apps/api/models"
	"google.golang.org/api/iterator"
)

// PaymentRepository handles payment data operations
type PaymentRepository struct {
	Client *firestore.Client
}

// NewPaymentRepository creates a new payment repository instance
func NewPaymentRepository(client *firestore.Client) *PaymentRepository {
	return &PaymentRepository{Client: client}
}

// GetByID retrieves a payment by ID
func (r *PaymentRepository) GetByID(ctx context.Context, id string) (*models.Payment, error) {
	doc, err := r.Client.Collection("payments").Doc(id).Get(ctx)
	if err != nil {
		return nil, err
	}

	var payment models.Payment
	if err := doc.DataTo(&payment); err != nil {
		return nil, err
	}

	return &payment, nil
}

// Create creates a new payment record
func (r *PaymentRepository) Create(ctx context.Context, payment *models.Payment) error {
	// Set timestamps
	now := time.Now()
	payment.CreatedAt = now
	payment.UpdatedAt = now

	// Set initial status if not provided
	if payment.Status == "" {
		payment.Status = "pending"
	}

	// Create document with generated ID if not provided
	var docRef *firestore.DocumentRef
	if payment.ID == "" {
		docRef = r.Client.Collection("payments").NewDoc()
		payment.ID = docRef.ID
	} else {
		docRef = r.Client.Collection("payments").Doc(payment.ID)
	}

	_, err := docRef.Set(ctx, payment)
	return err
}

// Update updates an existing payment
func (r *PaymentRepository) Update(ctx context.Context, payment *models.Payment) error {
	// Update timestamp
	payment.UpdatedAt = time.Now()

	// Update document
	_, err := r.Client.Collection("payments").Doc(payment.ID).Set(ctx, payment, firestore.MergeAll)
	return err
}

// UpdateStatus updates the status of a payment
func (r *PaymentRepository) UpdateStatus(ctx context.Context, paymentID, status string) error {
	_, err := r.Client.Collection("payments").Doc(paymentID).Update(ctx, []firestore.Update{
		{Path: "status", Value: status},
		{Path: "updated_at", Value: time.Now()},
	})
	return err
}

// GetByBHubID retrieves all payments for a specific BHub
func (r *PaymentRepository) GetByBHubID(ctx context.Context, bhubID string) ([]*models.Payment, error) {
	var payments []*models.Payment

	// Query for payments by BHub ID
	iter := r.Client.Collection("payments").Where("bhub_id", "==", bhubID).Documents(ctx)
	for {
		doc, err := iter.Next()
		if err == iterator.Done {
			break
		}
		if err != nil {
			return nil, err
		}

		var payment models.Payment
		if err := doc.DataTo(&payment); err != nil {
			return nil, err
		}

		payments = append(payments, &payment)
	}

	return payments, nil
}

// GetByUserID retrieves all payments for a specific user
func (r *PaymentRepository) GetByUserID(ctx context.Context, userID string) ([]*models.Payment, error) {
	var payments []*models.Payment

	// Query for payments by user ID
	iter := r.Client.Collection("payments").Where("user_id", "==", userID).Documents(ctx)
	for {
		doc, err := iter.Next()
		if err == iterator.Done {
			break
		}
		if err != nil {
			return nil, err
		}

		var payment models.Payment
		if err := doc.DataTo(&payment); err != nil {
			return nil, err
		}

		payments = append(payments, &payment)
	}

	return payments, nil
}
