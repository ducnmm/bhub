package config

import (
	"context"
	"errors"
	"os"

	"cloud.google.com/go/firestore"
	firebase "firebase.google.com/go/v4"
	"github.com/joho/godotenv"
	"google.golang.org/api/option"
)

// Config holds application configuration
type Config struct {
	Environment             string
	FirebaseCredentialsPath string
	ProjectID               string
}

// LoadConfig loads configuration from environment variables
func LoadConfig() (*Config, error) {
	// Load .env file
	if err := godotenv.Load(); err != nil {
		return nil, err
	}

	// Get environment or default to development
	env := os.Getenv("APP_ENV")
	if env == "" {
		env = "development"
	}

	// Get Firebase credentials path
	credentialsPath := os.Getenv("FIREBASE_CREDENTIALS_PATH")
	if credentialsPath == "" && env == "production" {
		return nil, errors.New("FIREBASE_CREDENTIALS_PATH is required in production")
	}

	// Get Google Cloud project ID
	projectID := os.Getenv("GOOGLE_CLOUD_PROJECT")
	if projectID == "" && env == "production" {
		return nil, errors.New("GOOGLE_CLOUD_PROJECT is required in production")
	}

	return &Config{
		Environment:             env,
		FirebaseCredentialsPath: credentialsPath,
		ProjectID:               projectID,
	}, nil
}

// InitFirebase initializes the Firebase app
func InitFirebase(ctx context.Context) (*firebase.App, error) {
	// Load configuration
	cfg, err := LoadConfig()
	if err != nil {
		return nil, err
	}

	// Configure Firebase options
	var opts []option.ClientOption
	if cfg.FirebaseCredentialsPath != "" {
		// Use service account credentials file if provided
		opts = append(opts, option.WithCredentialsFile(cfg.FirebaseCredentialsPath))
	}

	// Initialize Firebase app
	config := &firebase.Config{
		ProjectID: cfg.ProjectID,
	}

	app, err := firebase.NewApp(ctx, config, opts...)
	if err != nil {
		return nil, err
	}

	return app, nil
}

// InitFirestore initializes the Firestore client
func InitFirestore(ctx context.Context, app *firebase.App) (*firestore.Client, error) {
	// Get Firestore client from Firebase app
	client, err := app.Firestore(ctx)
	if err != nil {
		return nil, err
	}

	return client, nil
}
