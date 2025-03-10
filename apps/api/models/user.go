package models

import (
	"time"
)

// User represents a user in the system
type User struct {
	ID        string    `json:"id" firestore:"id"`
	Name      string    `json:"name" firestore:"name"`
	Email     string    `json:"email" firestore:"email"`
	PhotoURL  string    `json:"photo_url,omitempty" firestore:"photo_url,omitempty"`
	CreatedAt time.Time `json:"created_at" firestore:"created_at"`
	UpdatedAt time.Time `json:"updated_at" firestore:"updated_at"`
}

// UserResponse is the structure returned to clients
type UserResponse struct {
	ID       string `json:"user_id"`
	Name     string `json:"name"`
	Email    string `json:"email"`
	PhotoURL string `json:"photo_url,omitempty"`
	Token    string `json:"token,omitempty"`
}