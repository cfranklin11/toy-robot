package command

import (
	"testing"
)

func TestBuildCommand_validString(t *testing.T) {
	command, err := BuildCommand("PLACE")

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
