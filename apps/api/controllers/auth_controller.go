package controllers

import (
	"net/http"

	"github.com/ducnmm/bhub/apps/api/services"
	"github.com/gin-gonic/gin"
)

// AuthController handles authentication-related requests
type AuthController struct {
	AuthService *services.AuthService
}

// NewAuthController creates a new auth controller instance
func NewAuthController(authService *services.AuthService) *AuthController {
	return &AuthController{AuthService: authService}
}

// LoginRequest represents the login request body
type LoginRequest struct {
	IDToken string `json:"id_token" binding:"required"`
}

// Login handles user authentication with Firebase
func (c *AuthController) Login(ctx *gin.Context) {
	// Parse request body
	var req LoginRequest
	if err := ctx.ShouldBindJSON(&req); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request format"})
		return
	}

	// Verify ID token and get user info
	userResponse, err := c.AuthService.VerifyIDToken(ctx.Request.Context(), req.IDToken)
	if err != nil {
		ctx.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid ID token"})
		return
	}

	// Return user information
	ctx.JSON(http.StatusOK, userResponse)
}
