package game

import (
	"testing"

	"github.com/cfranklin11/toy-robot/internal/command"
	"github.com/cfranklin11/toy-robot/internal/robot"
	"github.com/cfranklin11/toy-robot/internal/table"
)

var validTable, _ = table.BuildTable(5, 5)
var validRobot, _ = robot.BuildRobot()
var validGame, _ = BuildGame(*validTable, *validRobot)

func TestBuildGame_validDimensions(t *testing.T) {
	game, err := BuildGame(*validTable, *validRobot)

	if err != nil {
		t.Fatalf("expected no error, got %v", err)
	}
	if game == nil {
		t.Fatalf("expected Game to be present, got %v", game)
	}
}

func TestExecuteCommand(t *testing.T) {
	game, _ := BuildGame(*validTable, *validRobot)
	command, _ := command.BuildCommand("MOVE")
	game.ExecuteCommand(*command)
}

func TestStartGame(t *testing.T) {
	game, err := StartGame()

	if err != nil {
		t.Fatalf("expected no error, got %v", err)
	}
	if game == nil {
		t.Fatalf("expected Game to be present, got %v", game)
	}
}

func TestHandleCommand_invalidCommand(t *testing.T) {
	err := HandleCommand(*validGame, "STUFF")

	if err == nil {
		t.Fatal("expected an error, got nil")
	}
}
