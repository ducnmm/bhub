package routes

import (
	"context"

	"cloud.google.com/go/firestore"
	firebase "firebase.google.com/go/v4"
	"github.com/ducnmm/bhub/apps/api/controllers"
	"github.com/ducnmm/bhub/apps/api/middleware"
	"github.com/ducnmm/bhub/apps/api/repositories"
	"github.com/ducnmm/bhub/apps/api/services"
	"github.com/gin-gonic/gin"
)

// SetupRoutes configures all API routes
func SetupRoutes(router *gin.Engine, ctx context.Context, firebaseApp *firebase.App, firestoreClient *firestore.Client) {
	// Initialize repositories
	userRepo := repositories.NewUserRepository(firestoreClient)
	bhubRepo := repositories.NewBHubRepository(firestoreClient)
	paymentRepo := repositories.NewPaymentRepository(firestoreClient)

	// Initialize services
	authService := services.NewAuthService(firebaseApp, userRepo)
	bhubService := services.NewBHubService(bhubRepo, userRepo)
	paymentService := services.NewPaymentService(paymentRepo, bhubRepo, userRepo)

	// Initialize controllers
	authController := controllers.NewAuthController(authService)
	bhubController := controllers.NewBHubController(bhubService)
	paymentController := controllers.NewPaymentController(paymentService)

	// Initialize middleware
	authMiddleware := middleware.NewAuthMiddleware(authService)

	// Set up CORS and other global middleware
	router.Use(gin.Logger())
	router.Use(gin.Recovery())

	// Health check endpoint
	router.GET("/health", func(c *gin.Context) {
		c.JSON(200, gin.H{"status": "ok"})
	})

	// Auth routes
	authRoutes := router.Group("/auth")
	{
		authRoutes.POST("/login", authController.Login)
	}

	// BHub routes
	bhubRoutes := router.Group("/bhub")
	bhubRoutes.Use(authMiddleware.VerifyToken())
	{
		bhubRoutes.POST("/create", bhubController.CreateBHub)
		bhubRoutes.GET("/list", bhubController.ListBHubs)
		bhubRoutes.GET("/:id", bhubController.GetBHub)
		bhubRoutes.POST("/:id/join", bhubController.JoinBHub)
	}

	// Payment routes
	paymentRoutes := router.Group("/payment")
	paymentRoutes.Use(authMiddleware.VerifyToken())
	{
		paymentRoutes.POST("", paymentController.ProcessPayment)
		paymentRoutes.POST("/refund", paymentController.ProcessRefund)
		paymentRoutes.GET("/user/:id", paymentController.GetPaymentsByUser)
		paymentRoutes.GET("/bhub/:id", paymentController.GetPaymentsByBHub)
		paymentRoutes.GET("/:id", paymentController.GetPaymentByID)
	}
}
