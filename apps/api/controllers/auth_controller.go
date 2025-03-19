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

// GoogleAuthRequest represents the Google authentication request body
type GoogleAuthRequest struct {
	IDToken string `json:"id_token" binding:"required"`
}

// GoogleLogin handles user authentication with Google
func (c *AuthController) GoogleLogin(ctx *gin.Context) {
	var req GoogleAuthRequest
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
