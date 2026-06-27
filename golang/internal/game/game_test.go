package game

import (
	"testing"

	"github.com/cfranklin11/toy-robot/internal/command"
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

func TestExecuteCommand(t *testing.T) {
	game, _ := BuildGame(5, 5)
	command, _ := command.BuildCommand("MOVE")
	game.ExecuteCommand(*command)
}
