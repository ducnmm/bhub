package models

import (
	"time"
)

// BHub represents a badminton hub group
type BHub struct {
	ID           string    `json:"id" firestore:"id"`
	HostID       string    `json:"host_id" firestore:"host_id"`
	Location     string    `json:"location" firestore:"location"`
	TimeSlot     time.Time `json:"time_slot" firestore:"time_slot"`
	MinMembers   int       `json:"min_members" firestore:"min_members"`
	MaxMembers   int       `json:"max_members" firestore:"max_members"`
	PriceTotal   float64   `json:"price_total" firestore:"price_total"`
	PricePerPerson float64  `json:"price_per_person" firestore:"price_per_person"`
	Status       string    `json:"status" firestore:"status"`
	Members      []string  `json:"members" firestore:"members"`
	CreatedAt    time.Time `json:"created_at" firestore:"created_at"`
	UpdatedAt    time.Time `json:"updated_at" firestore:"updated_at"`
}

// BHubResponse is the structure returned to clients
type BHubResponse struct {
	ID            string    `json:"id"`
	Location      string    `json:"location"`
	TimeSlot      time.Time `json:"time_slot"`
	CurrentMembers int       `json:"current_members"`
	MaxMembers    int       `json:"max_members"`
	PricePerPerson float64   `json:"price_per_person"`
	Host          string    `json:"host"`
	Status        string    `json:"status"`
}

// BHubCreateRequest represents the request to create a new BHub
type BHubCreateRequest struct {
	HostID     string    `json:"host_id" binding:"required"`
	Location   string    `json:"location" binding:"required"`
	TimeSlot   time.Time `json:"time_slot" binding:"required"`
	MinMembers int       `json:"min_members" binding:"required"`
	MaxMembers int       `json:"max_members" binding:"required"`
	PriceTotal float64   `json:"price_total" binding:"required"`
}

// BHubCreateResponse represents the response after creating a BHub
type BHubCreateResponse struct {
	BHubID         string  `json:"bhub_id"`
	PricePerPerson float64 `json:"price_per_person"`
}

// BHubJoinRequest represents the request to join a BHub
type BHubJoinRequest struct {
	UserID string `json:"user_id" binding:"required"`
	BHubID string `json:"bhub_id" binding:"required"`
}

// BHubJoinResponse represents the response after joining a BHub
type BHubJoinResponse struct {
	Message    string  `json:"message"`
	TotalPrice float64 `json:"total_price"`
}