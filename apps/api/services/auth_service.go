package services

import (
	"context"
	"errors"
	"time"

	firebase "firebase.google.com/go/v4"
	"github.com/ducnmm/bhub/apps/api/models"
	"github.com/ducnmm/bhub/apps/api/repositories"
)

// AuthService handles authentication operations
type AuthService struct {
	FirebaseApp *firebase.App
	UserRepo    *repositories.UserRepository
}

// NewAuthService creates a new authentication service
func NewAuthService(app *firebase.App, userRepo *repositories.UserRepository) *AuthService {
	return &AuthService{
		FirebaseApp: app,
		UserRepo:    userRepo,
	}
}

// VerifyIDToken verifies a Firebase ID token and returns the user information
func (s *AuthService) VerifyIDToken(ctx context.Context, idToken string) (*models.UserResponse, error) {
	// Get Firebase Auth client
	authClient, err := s.FirebaseApp.Auth(ctx)
	if err != nil {
		return nil, err
	}

	// Verify the ID token
	token, err := authClient.VerifyIDToken(ctx, idToken)
	if err != nil {
		return nil, err
	}

	// Get user from Firebase Auth
	firebaseUser, err := authClient.GetUser(ctx, token.UID)
	if err != nil {
		return nil, err
	}

	// Check if user exists in Firestore
	user, err := s.UserRepo.GetByID(ctx, token.UID)
	if err != nil || user == nil {
		// Create new user if not exists
		user = &models.User{
			ID:        token.UID,
			Name:      firebaseUser.DisplayName,
			Email:     firebaseUser.Email,
			PhotoURL:  firebaseUser.PhotoURL,
			CreatedAt: time.Now(),
			UpdatedAt: time.Now(),
		}

		// Save user to Firestore
		if err := s.UserRepo.Create(ctx, user); err != nil {
			return nil, err
		}
	}

	// Create custom token for client
	customToken, err := authClient.CustomToken(ctx, user.ID)
	if err != nil {
		return nil, err
	}

	// Return user response
	return &models.UserResponse{
		ID:       user.ID,
		Name:     user.Name,
		Email:    user.Email,
		PhotoURL: user.PhotoURL,
		Token:    customToken,
	}, nil
}

// GetUserByID retrieves a user by ID
func (s *AuthService) GetUserByID(ctx context.Context, userID string) (*models.User, error) {
	return s.UserRepo.GetByID(ctx, userID)
}

// VerifyUser verifies if a user exists and is valid
func (s *AuthService) VerifyUser(ctx context.Context, userID string) error {
	// Get Firebase Auth client
	authClient, err := s.FirebaseApp.Auth(ctx)
	if err != nil {
		return err
	}

	// Check if user exists in Firebase Auth
	_, err = authClient.GetUser(ctx, userID)
	if err != nil {
		return errors.New("invalid user ID")
	}

	// Check if user exists in Firestore
	user, err := s.UserRepo.GetByID(ctx, userID)
	if err != nil || user == nil {
		return errors.New("user not found in database")
	}

	return nil
}
