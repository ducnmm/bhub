package repositories

import (
	"context"
	"time"

	"cloud.google.com/go/firestore"
	"github.com/ducnmm/bhub/apps/api/models"
	"google.golang.org/api/iterator"
)

// BHubRepository handles BHub data operations
type BHubRepository struct {
	Client *firestore.Client
}

// NewBHubRepository creates a new BHub repository instance
func NewBHubRepository(client *firestore.Client) *BHubRepository {
	return &BHubRepository{Client: client}
}

// GetByID retrieves a BHub by ID
func (r *BHubRepository) GetByID(ctx context.Context, id string) (*models.BHub, error) {
	doc, err := r.Client.Collection("bhubs").Doc(id).Get(ctx)
	if err != nil {
		return nil, err
	}

	var bhub models.BHub
	if err := doc.DataTo(&bhub); err != nil {
		return nil, err
	}

	return &bhub, nil
}

// Create creates a new BHub
func (r *BHubRepository) Create(ctx context.Context, bhub *models.BHub) error {
	// Set timestamps
	now := time.Now()
	bhub.CreatedAt = now
	bhub.UpdatedAt = now

	// Initialize members array if nil
	if bhub.Members == nil {
		bhub.Members = []string{bhub.HostID} // Add host as first member
	}

	// Set initial status
	bhub.Status = "open"

	// Calculate price per person
	if bhub.MaxMembers > 0 {
		bhub.PricePerPerson = bhub.PriceTotal / float64(bhub.MaxMembers)
	}

	// Create document with generated ID if not provided
	var docRef *firestore.DocumentRef
	if bhub.ID == "" {
		docRef = r.Client.Collection("bhubs").NewDoc()
		bhub.ID = docRef.ID
	} else {
		docRef = r.Client.Collection("bhubs").Doc(bhub.ID)
	}

	_, err := docRef.Set(ctx, bhub)
	return err
}

// Update updates an existing BHub
func (r *BHubRepository) Update(ctx context.Context, bhub *models.BHub) error {
	// Update timestamp
	bhub.UpdatedAt = time.Now()

	// Update document
	_, err := r.Client.Collection("bhubs").Doc(bhub.ID).Set(ctx, bhub, firestore.MergeAll)
	return err
}

// AddMember adds a user to a BHub
func (r *BHubRepository) AddMember(ctx context.Context, bhubID, userID string) error {
	// Get BHub
	bhub, err := r.GetByID(ctx, bhubID)
	if err != nil {
		return err
	}

	// Check if user is already a member
	for _, member := range bhub.Members {
		if member == userID {
			return nil // User is already a member
		}
	}

	// Add user to members
	bhub.Members = append(bhub.Members, userID)

	// Update BHub
	return r.Update(ctx, bhub)
}

// List retrieves BHubs based on filters
func (r *BHubRepository) List(ctx context.Context, location string, timeAfter time.Time) ([]*models.BHub, error) {
	var bhubs []*models.BHub

	// Start with base query
	query := r.Client.Collection("bhubs").Where("status", "==", "open")

	// Add location filter if provided
	if location != "" {
		query = query.Where("location", "==", location)
	}

	// Add time filter if provided
	if !timeAfter.IsZero() {
		query = query.Where("time_slot", ">=", timeAfter)
	}

	// Execute query
	iter := query.Documents(ctx)
	for {
		doc, err := iter.Next()
		if err == iterator.Done {
			break
		}
		if err != nil {
			return nil, err
		}

		var bhub models.BHub
		if err := doc.DataTo(&bhub); err != nil {
			return nil, err
		}

		bhubs = append(bhubs, &bhub)
	}

	return bhubs, nil
}

// UpdateStatus updates the status of a BHub
func (r *BHubRepository) UpdateStatus(ctx context.Context, bhubID, status string) error {
	_, err := r.Client.Collection("bhubs").Doc(bhubID).Update(ctx, []firestore.Update{
		{Path: "status", Value: status},
		{Path: "updated_at", Value: time.Now()},
	})
	return err
}

// GetUpcomingBHubs retrieves BHubs that are scheduled to start soon
func (r *BHubRepository) GetUpcomingBHubs(ctx context.Context, timeWindow time.Duration) ([]*models.BHub, error) {
	var bhubs []*models.BHub

	// Calculate time range
	now := time.Now()
	upcomingTime := now.Add(timeWindow)

	// Query for upcoming BHubs
	iter := r.Client.Collection("bhubs").Where("status", "==", "open").Where("time_slot", "<=", upcomingTime).Where("time_slot", ">=", now).Documents(ctx)
	for {
		doc, err := iter.Next()
		if err == iterator.Done {
			break
		}
		if err != nil {
			return nil, err
		}

		var bhub models.BHub
		if err := doc.DataTo(&bhub); err != nil {
			return nil, err
		}

		bhubs = append(bhubs, &bhub)
	}

	return bhubs, nil
}
