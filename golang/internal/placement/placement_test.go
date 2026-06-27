package placement

import (
	"testing"
)

func TestBuildCoordinate_positiveNumber(t *testing.T) {
	coordinate, err := BuildCoordinate("42")

	if err != nil {
		t.Fatalf("expected err to be nil, got %v", err)
	}
	if coordinate == nil {
		t.Fatal("expected coordinate to be present, got nil")
	}
}

func TestBuildCoordinate_negativeNumber(t *testing.T) {
	coordinate, err := BuildCoordinate("-42")

	if err == nil {
		t.Fatal("expected err to be present, got nil")
	}
	if coordinate != nil {
		t.Fatalf("expected coordinate to be nil, got %v", coordinate)
	}
}

func TestBuildCoordinate_zero(t *testing.T) {
	coordinate, err := BuildCoordinate("0")

	if err != nil {
		t.Fatalf("expected err to be nil, got %v", err)
	}
	if coordinate == nil {
		t.Fatal("expected coordinate to be present, got nil")
	}
}

func TestBuildCoordinate_notNumeric(t *testing.T) {
	coordinate, err := BuildCoordinate("stuff")

	if err == nil {
		t.Fatal("expected err to be present, got nil")
	}
	if coordinate != nil {
		t.Fatalf("expected coordinate to be nil, got %v", coordinate)
	}
}

func TestBuildDirection_validValue(t *testing.T) {
	direction, err := BuildDirection("NORTH")

	if err != nil {
		t.Fatalf("expected err to be nil, got %v", err)
	}
	if direction == nil {
		t.Fatal("expected direction to be present, got nil")
	}
}

func TestBuildCoordinate_invalidValue(t *testing.T) {
	direction, err := BuildDirection("STUFF")

	if err == nil {
		t.Fatal("expected err to be present, got nil")
	}
	if direction != nil {
		t.Fatalf("expected direction to be nil, got %v", direction)
	}
}
