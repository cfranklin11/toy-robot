package game

import (
	"testing"
)

func TestBuildGame_validDimensions(t *testing.T) {
	game, err := BuildGame(5, 5)

	if err != nil {
		t.Fatalf("expected no error, got %v", err)
	}
	if game == nil {
		t.Fatalf("expected Game to be present, got %v", game)
	}
}
