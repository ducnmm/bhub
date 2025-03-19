package controllers

import (
	"net/http"

	"github.com/ducnmm/bhub/apps/api/services"
	"github.com/gin-gonic/gin"
)

// UserController handles user-related HTTP requests
type UserController struct {
	authService *services.AuthService
}

// NewUserController creates a new user controller
func NewUserController(authService *services.AuthService) *UserController {
	return &UserController{
		authService: authService,
	}
}

// GetUser handles GET /api/users/:id requests
func (c *UserController) GetUser(ctx *gin.Context) {
	userID := ctx.Param("id")
	if userID == "" {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": "user ID is required"})
		return
	}

	user, err := c.authService.GetUserByID(ctx, userID)
	if err != nil {
		ctx.JSON(http.StatusNotFound, gin.H{"error": "user not found"})
		return
	}

	ctx.JSON(http.StatusOK, user)
}
