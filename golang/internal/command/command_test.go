package command

import (
	"testing"
)

func TestBuildCommand_validString(t *testing.T) {
	command, err := BuildCommand("LEFT")

	if err != nil {
		t.Fatalf("expected no error, got %v", err)
	}

	if command == nil {
		t.Fatalf("expected command to be present, got nil")
	}
}

func TestBuildCommand_invalidString(t *testing.T) {
	command, err := BuildCommand("STUFF")

	if err == nil {
		t.Fatal("expected error to be present, got nil")
	}
	if command != nil {
		t.Fatalf("expected command to be nil, got %v", command)
	}
}

func TestBuildPlaceCommand_validString(t *testing.T) {
	placeCommand, err := BuildPlaceCommand("PLACE 1, 2, WEST")

	if err != nil {
		t.Fatalf("expected no error, got %v", err)
	}

	if placeCommand == nil {
		t.Fatalf("expected placeCommand to be present, got nil")
	}
}

func TestBuildPlaceCommand_invalidString(t *testing.T) {
	placeCommand, err := BuildCommand("PLACE 1, 2")

	if err == nil {
		t.Fatal("expected error to be present, got nil")
	}
	if placeCommand != nil {
		t.Fatalf("expected placeCommand to be nil, got %v", placeCommand)
	}
}

func TestIsPlaceCommand_isPlace(t *testing.T) {
	isPlaceCommand := IsPlaceCommand("PLACE")
	if isPlaceCommand == false {
		t.Fatal("expected IsPlaceCommand to be true, got false")
	}
}

func TestIsPlaceCommand_isNotPlace(t *testing.T) {
	isPlaceCommand := IsPlaceCommand("STUFF 42, 24, NORTH")
	if isPlaceCommand == true {
		t.Fatal("expected IsPlaceCommand to be false, got true")
	}
}
