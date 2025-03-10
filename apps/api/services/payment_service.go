package services

import (
	"context"
	"errors"
	"time"

	"github.com/ducnmm/bhub/apps/api/models"
	"github.com/ducnmm/bhub/apps/api/repositories"
)

// PaymentService handles payment operations
type PaymentService struct {
	PaymentRepo *repositories.PaymentRepository
	BHubRepo    *repositories.BHubRepository
	UserRepo    *repositories.UserRepository
}

// NewPaymentService creates a new payment service instance
func NewPaymentService(paymentRepo *repositories.PaymentRepository, bhubRepo *repositories.BHubRepository, userRepo *repositories.UserRepository) *PaymentService {
	return &PaymentService{
		PaymentRepo: paymentRepo,
		BHubRepo:    bhubRepo,
		UserRepo:    userRepo,
	}
}

// ProcessPayment handles payment processing
func (s *PaymentService) ProcessPayment(ctx context.Context, req *models.PaymentRequest) (*models.PaymentResponse, error) {
	// Verify user exists
	user, err := s.UserRepo.GetByID(ctx, req.UserID)
	if err != nil || user == nil {
		return nil, errors.New("invalid user ID")
	}

	// Verify BHub exists
	bhub, err := s.BHubRepo.GetByID(ctx, req.BHubID)
	if err != nil || bhub == nil {
		return nil, errors.New("invalid BHub ID")
	}

	// Verify payment method
	if req.PaymentMethod != "google_pay" && req.PaymentMethod != "vnpay" {
		return nil, errors.New("unsupported payment method")
	}

	// Create payment record
	payment := &models.Payment{
		UserID:        req.UserID,
		BHubID:        req.BHubID,
		Amount:        req.Amount,
		PaymentMethod: req.PaymentMethod,
		Status:        "pending",
	}

	// Save payment to database
	if err := s.PaymentRepo.Create(ctx, payment); err != nil {
		return nil, err
	}

	// TODO: Integrate with actual payment gateway (Google Pay or VNPay)
	// This would involve calling external APIs and handling callbacks
	// For now, we'll simulate a successful payment

	// Update payment status to completed
	payment.Status = "completed"
	payment.UpdatedAt = time.Now()
	if err := s.PaymentRepo.Update(ctx, payment); err != nil {
		return nil, err
	}

	return &models.PaymentResponse{
		PaymentID: payment.ID,
		Status:    payment.Status,
	}, nil
}

// ProcessRefund handles refunding payments for a BHub
func (s *PaymentService) ProcessRefund(ctx context.Context, req *models.RefundRequest) (*models.RefundResponse, error) {
	// Verify BHub exists
	bhub, err := s.BHubRepo.GetByID(ctx, req.BHubID)
	if err != nil || bhub == nil {
		return nil, errors.New("invalid BHub ID")
	}

	// Get all payments for this BHub
	payments, err := s.PaymentRepo.GetByBHubID(ctx, req.BHubID)
	if err != nil {
		return nil, err
	}

	// Process refunds for each payment
	for _, payment := range payments {
		// Skip payments that are not completed or already refunded
		if payment.Status != "completed" {
			continue
		}

		// TODO: Integrate with actual payment gateway for refund processing
		// This would involve calling external APIs
		// For now, we'll simulate a successful refund

		// Update payment status to refunded
		payment.Status = "refunded"
		payment.UpdatedAt = time.Now()
		if err := s.PaymentRepo.Update(ctx, payment); err != nil {
			return nil, err
		}
	}

	// Update BHub status to cancelled
	if err := s.BHubRepo.UpdateStatus(ctx, req.BHubID, "cancelled"); err != nil {
		return nil, err
	}

	return &models.RefundResponse{
		Message: "Refund processed successfully",
	}, nil
}

// GetPaymentsByUser retrieves all payments for a specific user
func (s *PaymentService) GetPaymentsByUser(ctx context.Context, userID string) ([]*models.Payment, error) {
	return s.PaymentRepo.GetByUserID(ctx, userID)
}

// GetPaymentsByBHub retrieves all payments for a specific BHub
func (s *PaymentService) GetPaymentsByBHub(ctx context.Context, bhubID string) ([]*models.Payment, error) {
	return s.PaymentRepo.GetByBHubID(ctx, bhubID)
}

// GetPaymentByID retrieves a specific payment by ID
func (s *PaymentService) GetPaymentByID(ctx context.Context, paymentID string) (*models.Payment, error) {
	return s.PaymentRepo.GetByID(ctx, paymentID)
}
