package repositories

import (
	"context"
	"time"

	"cloud.google.com/go/firestore"
	"github.com/ducnmm/bhub/apps/api/models"
	"google.golang.org/api/iterator"
)

// UserRepository handles user data operations
type UserRepository struct {
	Client *firestore.Client
}

// NewUserRepository creates a new user repository instance
func NewUserRepository(client *firestore.Client) *UserRepository {
	return &UserRepository{Client: client}
}

// GetByID retrieves a user by ID
func (r *UserRepository) GetByID(ctx context.Context, id string) (*models.User, error) {
	doc, err := r.Client.Collection("users").Doc(id).Get(ctx)
	if err != nil {
		return nil, err
	}

	var user models.User
	if err := doc.DataTo(&user); err != nil {
		return nil, err
	}

	return &user, nil
}

// GetByEmail retrieves a user by email
func (r *UserRepository) GetByEmail(ctx context.Context, email string) (*models.User, error) {
	iter := r.Client.Collection("users").Where("email", "==", email).Limit(1).Documents(ctx)
	doc, err := iter.Next()
	if err == iterator.Done {
		return nil, nil
	}
	if err != nil {
		return nil, err
	}

	var user models.User
	if err := doc.DataTo(&user); err != nil {
		return nil, err
	}

	return &user, nil
}

// Create creates a new user
func (r *UserRepository) Create(ctx context.Context, user *models.User) error {
	// Set timestamps
	now := time.Now()
	user.CreatedAt = now
	user.UpdatedAt = now

	// Create document with user ID
	_, err := r.Client.Collection("users").Doc(user.ID).Set(ctx, user)
	return err
}

// Update updates an existing user
func (r *UserRepository) Update(ctx context.Context, user *models.User) error {
	// Update timestamp
	user.UpdatedAt = time.Now()

	// Update document
	_, err := r.Client.Collection("users").Doc(user.ID).Set(ctx, user, firestore.MergeAll)
	return err
}
