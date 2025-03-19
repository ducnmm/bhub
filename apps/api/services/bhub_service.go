package services

import (
	"context"
	"errors"
	"time"

	"github.com/ducnmm/bhub/apps/api/models"
	"github.com/ducnmm/bhub/apps/api/repositories"
)

// BHubService handles BHub operations
type BHubService struct {
	BHubRepo *repositories.BHubRepository
	UserRepo *repositories.UserRepository
}

// NewBHubService creates a new BHub service instance
func NewBHubService(bhubRepo *repositories.BHubRepository, userRepo *repositories.UserRepository) *BHubService {
	return &BHubService{
		BHubRepo: bhubRepo,
		UserRepo: userRepo,
	}
}

// CreateBHub creates a new BHub
func (s *BHubService) CreateBHub(ctx context.Context, req *models.BHubCreateRequest) (*models.BHubCreateResponse, error) {
	// Verify host exists
	host, err := s.UserRepo.GetByID(ctx, req.HostID)
	if err != nil || host == nil {
		return nil, errors.New("invalid host ID")
	}

	// Create BHub
	bhub := &models.BHub{
		HostID:     req.HostID,
		Location:   req.Location,
		TimeSlot:   req.TimeSlot,
		MinMembers: req.MinMembers,
		MaxMembers: req.MaxMembers,
		PriceTotal: req.PriceTotal,
	}

	// Save BHub
	if err := s.BHubRepo.Create(ctx, bhub); err != nil {
		return nil, err
	}

	return &models.BHubCreateResponse{
		BHubID:         bhub.ID,
		PricePerPerson: bhub.PricePerPerson,
	}, nil
}

// JoinBHub handles a user joining a BHub
func (s *BHubService) JoinBHub(ctx context.Context, req *models.BHubJoinRequest) (*models.BHubJoinResponse, error) {
	// Get BHub
	bhub, err := s.BHubRepo.GetByID(ctx, req.BHubID)
	if err != nil {
		return nil, err
	}

	// Verify user exists
	user, err := s.UserRepo.GetByID(ctx, req.UserID)
	if err != nil || user == nil {
		return nil, errors.New("invalid user ID")
	}

	// Check if BHub is full
	if len(bhub.Members) >= bhub.MaxMembers {
		return nil, errors.New("BHub is full")
	}

	// Check if BHub is still open
	if bhub.Status != "open" {
		return nil, errors.New("BHub is not open for joining")
	}

	// Add member to BHub
	if err := s.BHubRepo.AddMember(ctx, req.BHubID, req.UserID); err != nil {
		return nil, err
	}

	return &models.BHubJoinResponse{
		Message:    "Successfully joined BHub",
		TotalPrice: bhub.PricePerPerson,
	}, nil
}

// ListBHubs retrieves available BHubs
func (s *BHubService) ListBHubs(ctx context.Context) ([]*models.BHubResponse, error) {  // Removed location parameter
    // Get BHubs from current time onwards
    bhubs, err := s.BHubRepo.List(ctx, time.Now())
    if err != nil {
        return nil, err
    }

    var responses []*models.BHubResponse
    for _, bhub := range bhubs {
        // Get host information
        host, err := s.UserRepo.GetByID(ctx, bhub.HostID)
        if err != nil {
            continue
        }

        responses = append(responses, &models.BHubResponse{
            ID:             bhub.ID,
            Location:       bhub.Location,
            TimeSlot:       bhub.TimeSlot,
            CurrentMembers: len(bhub.Members),
            MaxMembers:     bhub.MaxMembers,
            PricePerPerson: bhub.PricePerPerson,
            Host:           host.Name,
            Status:         bhub.Status,
        })
    }

    return responses, nil
}

// GetBHub retrieves a specific BHub by ID
func (s *BHubService) GetBHub(ctx context.Context, id string) (*models.BHubResponse, error) {
	// Get BHub
	bhub, err := s.BHubRepo.GetByID(ctx, id)
	if err != nil {
		return nil, err
	}

	// Get host information
	host, err := s.UserRepo.GetByID(ctx, bhub.HostID)
	if err != nil {
		return nil, err
	}

	return &models.BHubResponse{
		ID:             bhub.ID,
		Location:       bhub.Location,
		TimeSlot:       bhub.TimeSlot,
		CurrentMembers: len(bhub.Members),
		MaxMembers:     bhub.MaxMembers,
		PricePerPerson: bhub.PricePerPerson,
		Host:           host.Name,
		Status:         bhub.Status,
	}, nil
}
