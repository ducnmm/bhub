package main

import (
	"context"
	"log"
	"os"

	"github.com/ducnmm/bhub/apps/api/config"
	"github.com/ducnmm/bhub/apps/api/routes"
	"github.com/gin-gonic/gin" // You need to run: go get -u github.com/gin-gonic/gin
)

func main() {
	// Initialize context
	ctx := context.Background()

	// Load configuration
	cfg, err := config.LoadConfig()
	if err != nil {
		log.Fatalf("Failed to load configuration: %v", err)
	}

	// Initialize Firebase app
	firebaseApp, err := config.InitFirebase(ctx)
	if err != nil {
		log.Fatalf("Failed to initialize Firebase: %v", err)
	}

	// Initialize Firestore client
	firestoreClient, err := config.InitFirestore(ctx, firebaseApp)
	if err != nil {
		log.Fatalf("Failed to initialize Firestore: %v", err)
	}
	defer firestoreClient.Close()

	// Set Gin mode
	if cfg.Environment == "production" {
		gin.SetMode(gin.ReleaseMode)
	}

	// Initialize router
	router := gin.Default()

	// Setup routes
	routes.SetupRoutes(router, ctx, firebaseApp, firestoreClient)

	// Get port from environment or use default
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	// Start server
	log.Printf("Server starting on port %s...", port)
	if err := router.Run(":" + port); err != nil {
		log.Fatalf("Failed to start server: %v", err)
	}
}
