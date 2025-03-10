package controllers

import (
	"net/http"

	"github.com/ducnmm/bhub/apps/api/models"
	"github.com/ducnmm/bhub/apps/api/services"
	"github.com/gin-gonic/gin"
)

// PaymentController handles payment-related requests
type PaymentController struct {
	PaymentService *services.PaymentService
}

// NewPaymentController creates a new payment controller instance
func NewPaymentController(paymentService *services.PaymentService) *PaymentController {
	return &PaymentController{PaymentService: paymentService}
}

// ProcessPayment handles payment processing
func (c *PaymentController) ProcessPayment(ctx *gin.Context) {
	// Parse request body
	var req models.PaymentRequest
	if err := ctx.ShouldBindJSON(&req); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request format"})
		return
	}

	// Process payment
	response, err := c.PaymentService.ProcessPayment(ctx.Request.Context(), &req)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	// Return response
	ctx.JSON(http.StatusOK, response)
}

// ProcessRefund handles refunding payments for a BHub
func (c *PaymentController) ProcessRefund(ctx *gin.Context) {
	// Parse request body
	var req models.RefundRequest
	if err := ctx.ShouldBindJSON(&req); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request format"})
		return
	}

	// Process refund
	response, err := c.PaymentService.ProcessRefund(ctx.Request.Context(), &req)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	// Return response
	ctx.JSON(http.StatusOK, response)
}

// GetPaymentsByUser retrieves all payments for a specific user
func (c *PaymentController) GetPaymentsByUser(ctx *gin.Context) {
	// Get user ID from URL parameter
	userID := ctx.Param("id")
	if userID == "" {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": "User ID is required"})
		return
	}

	// Get payments
	payments, err := c.PaymentService.GetPaymentsByUser(ctx.Request.Context(), userID)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	// Return response
	ctx.JSON(http.StatusOK, payments)
}

// GetPaymentsByBHub retrieves all payments for a specific BHub
func (c *PaymentController) GetPaymentsByBHub(ctx *gin.Context) {
	// Get BHub ID from URL parameter
	bhubID := ctx.Param("id")
	if bhubID == "" {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": "BHub ID is required"})
		return
	}

	// Get payments
	payments, err := c.PaymentService.GetPaymentsByBHub(ctx.Request.Context(), bhubID)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	// Return response
	ctx.JSON(http.StatusOK, payments)
}

// GetPaymentByID retrieves a specific payment by ID
func (c *PaymentController) GetPaymentByID(ctx *gin.Context) {
	// Get payment ID from URL parameter
	paymentID := ctx.Param("id")
	if paymentID == "" {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": "Payment ID is required"})
		return
	}

	// Get payment
	payment, err := c.PaymentService.GetPaymentByID(ctx.Request.Context(), paymentID)
	if err != nil {
		ctx.JSON(http.StatusNotFound, gin.H{"error": "Payment not found"})
		return
	}

	// Return response
	ctx.JSON(http.StatusOK, payment)
}
