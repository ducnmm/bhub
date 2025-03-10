package middleware

import (
	"net/http"
	"strings"

	"github.com/ducnmm/bhub/apps/api/services"
	"github.com/gin-gonic/gin"
)

// AuthMiddleware handles authentication and authorization
type AuthMiddleware struct {
	AuthService *services.AuthService
}

// NewAuthMiddleware creates a new auth middleware instance
func NewAuthMiddleware(authService *services.AuthService) *AuthMiddleware {
	return &AuthMiddleware{AuthService: authService}
}

// VerifyToken verifies the JWT token in the Authorization header
func (m *AuthMiddleware) VerifyToken() gin.HandlerFunc {
	return func(c *gin.Context) {
		// Get the Authorization header
		authHeader := c.GetHeader("Authorization")
		if authHeader == "" {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Authorization header is required"})
			c.Abort()
			return
		}

		// Check if the header has the Bearer prefix
		parts := strings.Split(authHeader, " ")
		if len(parts) != 2 || parts[0] != "Bearer" {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Authorization header format must be Bearer {token}"})
			c.Abort()
			return
		}

		// Extract the token
		token := parts[1]

		// Verify the token
		userResponse, err := m.AuthService.VerifyIDToken(c.Request.Context(), token)
		if err != nil {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid or expired token"})
			c.Abort()
			return
		}

		// Set user ID in context for later use
		c.Set("user_id", userResponse.ID)
		c.Next()
	}
}
