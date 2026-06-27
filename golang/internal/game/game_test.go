package game

import (
	"testing"

	"github.com/cfranklin11/toy-robot/internal/command"
	"github.com/cfranklin11/toy-robot/internal/robot"
	"github.com/cfranklin11/toy-robot/internal/table"
)

func TestBuildGame_validDimensions(t *testing.T) {
	validTable, _ := table.BuildTable(5, 5)
	validRobot, _ := robot.BuildRobot()
	game, err := BuildGame(*validTable, *validRobot)

	if err != nil {
		t.Fatalf("expected no error, got %v", err)
	}
	if game == nil {
		t.Fatalf("expected Game to be present, got %v", game)
	}
}

func TestExecuteCommand(t *testing.T) {
	validTable, _ := table.BuildTable(5, 5)
	validRobot, _ := robot.BuildRobot()
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
	validTable, _ := table.BuildTable(5, 5)
	validRobot, _ := robot.BuildRobot()
	validGame, _ := BuildGame(*validTable, *validRobot)
	err := HandleCommand(validGame, "STUFF")

	if err == nil {
		t.Fatal("expected an error, got nil")
	}
}

func TestHandleCommand_validPlaceCommand(t *testing.T) {
	validTable, _ := table.BuildTable(5, 5)
	validRobot, _ := robot.BuildRobot()
	validGame, _ := BuildGame(*validTable, *validRobot)
	err := HandleCommand(validGame, "PLACE 1, 2, WEST")

	if err != nil {
		t.Fatalf("expected no error, but got %v", err)
	}
	if validGame.Robot.Direction == nil {
		t.Fatal("expected Robot to be placed, got nil direction")
	}
}

func TestHandleCommand_invalidPlaceCommand(t *testing.T) {
	validTable, _ := table.BuildTable(5, 5)
	validRobot, _ := robot.BuildRobot()
	validGame, _ := BuildGame(*validTable, *validRobot)
	err := HandleCommand(validGame, "PLACE")

	if err == nil {
		t.Fatal("expected error to be present, got nil")
	}
	if validGame.Robot.Direction != nil {
		t.Fatal("expected Robot to still be unplaced, but direction is present")
	}
}
