package controllers

import (
	"net/http"

	"github.com/ducnmm/bhub/apps/api/models"
	"github.com/ducnmm/bhub/apps/api/services"
	"github.com/gin-gonic/gin"
)

// BHubController handles BHub-related requests
type BHubController struct {
	BHubService *services.BHubService
}

// NewBHubController creates a new BHub controller instance
func NewBHubController(bhubService *services.BHubService) *BHubController {
	return &BHubController{BHubService: bhubService}
}

// CreateBHub handles the creation of a new BHub
func (c *BHubController) CreateBHub(ctx *gin.Context) {
	// Parse request body
	var req models.BHubCreateRequest
	if err := ctx.ShouldBindJSON(&req); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request format"})
		return
	}

	// Create BHub
	response, err := c.BHubService.CreateBHub(ctx.Request.Context(), &req)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	// Return response
	ctx.JSON(http.StatusCreated, response)
}

// ListBHubs handles retrieving a list of available BHubs
func (c *BHubController) ListBHubs(ctx *gin.Context) {
    // Get BHubs
    bhubs, err := c.BHubService.ListBHubs(ctx.Request.Context())  // Removed location parameter
    if err != nil {
        ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
        return
    }

    // Return response
    ctx.JSON(http.StatusOK, bhubs)
}

// GetBHub handles retrieving a specific BHub by ID
func (c *BHubController) GetBHub(ctx *gin.Context) {
	// Get BHub ID from URL parameter
	id := ctx.Param("id")
	if id == "" {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": "BHub ID is required"})
		return
	}

	// Get BHub
	bhub, err := c.BHubService.GetBHub(ctx.Request.Context(), id)
	if err != nil {
		ctx.JSON(http.StatusNotFound, gin.H{"error": "BHub not found"})
		return
	}

	// Return response
	ctx.JSON(http.StatusOK, bhub)
}

// JoinBHub handles a user joining a BHub
func (c *BHubController) JoinBHub(ctx *gin.Context) {
	// Get BHub ID from URL parameter
	bhubID := ctx.Param("id")
	if bhubID == "" {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": "BHub ID is required"})
		return
	}

	// Get user ID from request body
	var req struct {
		UserID string `json:"user_id" binding:"required"`
	}
	if err := ctx.ShouldBindJSON(&req); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request format"})
		return
	}

	// Create join request
	joinReq := &models.BHubJoinRequest{
		UserID: req.UserID,
		BHubID: bhubID,
	}

	// Join BHub
	response, err := c.BHubService.JoinBHub(ctx.Request.Context(), joinReq)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	// Return response
	ctx.JSON(http.StatusOK, response)
}
