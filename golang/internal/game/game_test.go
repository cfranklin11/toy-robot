package game

import (
	"testing"

	"github.com/cfranklin11/toy-robot/internal/robot"
	"github.com/cfranklin11/toy-robot/internal/table"
)

func gameFactory() *Game {
	validTable, _ := table.BuildTable()
	validRobot, _ := robot.BuildRobot()
	validGame, _ := BuildGame(*validTable, *validRobot)
	return validGame
}

func TestBuildGame_validDimensions(t *testing.T) {
	validTable, _ := table.BuildTable()
	validRobot, _ := robot.BuildRobot()
	game, err := BuildGame(*validTable, *validRobot)

	if err != nil {
		t.Fatalf("expected no error, got %v", err)
	}
	if game == nil {
		t.Fatalf("expected Game to be present, got %v", game)
	}
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
	validGame := gameFactory()
	_, err := HandleCommand(validGame, "STUFF")

	if err == nil {
		t.Fatal("expected an error, got nil")
	}
}

func TestHandleCommand_validPlaceCommand(t *testing.T) {
	validGame := gameFactory()
	_, err := HandleCommand(validGame, "PLACE 1, 2, WEST")

	if err != nil {
		t.Fatalf("expected no error, but got %v", err)
	}
	report, _ := validGame.robot.Report()
	if report == nil {
		t.Fatal("expected Robot to be placed, but report was nil")
	}
}

func TestHandleCommand_invalidPlaceCommand(t *testing.T) {
	validGame := gameFactory()
	_, err := HandleCommand(validGame, "PLACE")

	if err == nil {
		t.Fatal("expected error to be present, got nil")
	}
	report, _ := validGame.robot.Report()
	if report != nil {
		t.Fatalf("expected Robot not to be placed, but report was %s", *report)
	}
}

func TestHandleCommand_reportCommand(t *testing.T) {
	validGame := gameFactory()
	HandleCommand(validGame, "PLACE 1, 2, SOUTH")
	response, err := HandleCommand(validGame, "REPORT")

	if err != nil {
		t.Fatalf("expected no error, but got %v", err)
	}
	if response == nil {
		t.Fatal("expected response to be present, got nil")
	}
}

func TestHandleCommand_moveCommand(t *testing.T) {
	validGame := gameFactory()
	HandleCommand(validGame, "PLACE 1, 2, SOUTH")
	response, err := HandleCommand(validGame, "MOVE")

	if err != nil {
		t.Fatalf("expected no error, but got %v", err)
	}
	if response == nil {
		t.Fatal("expected response to be present, got nil")
	}
}

func TestHandleCommand_moveCommandAtEdge(t *testing.T) {
	validGame := gameFactory()
	HandleCommand(validGame, "PLACE 1, 0, SOUTH")
	response, err := HandleCommand(validGame, "MOVE")

	if err == nil {
		t.Fatal("expected error to be present, but got nil")
	}
	if response != nil {
		t.Fatalf("expected response to be nil, got %s", *response)
	}
}

func TestHandleCommand_leftCommand(t *testing.T) {
	validGame := gameFactory()
	HandleCommand(validGame, "PLACE 1, 2, SOUTH")
	response, err := HandleCommand(validGame, "LEFT")

	if err != nil {
		t.Fatalf("expected no error, but got %v", err)
	}
	if response == nil {
		t.Fatal("expected response to be present, got nil")
	}
}

func TestHandleCommand_leftCommandUnplaced(t *testing.T) {
	validGame := gameFactory()
	response, err := HandleCommand(validGame, "LEFT")

	if err == nil {
		t.Fatal("expected error to be present, but got nil")
	}
	if response != nil {
		t.Fatalf("expected no response, got %s", *response)
	}
}

func TestHandleCommand_rightCommand(t *testing.T) {
	validGame := gameFactory()
	HandleCommand(validGame, "PLACE 1, 2, SOUTH")
	response, err := HandleCommand(validGame, "RIGHT")

	if err != nil {
		t.Fatalf("expected no error, but got %v", err)
	}
	if response == nil {
		t.Fatal("expected response to be present, got nil")
	}
}

func TestHandleCommand_rightCommandUnplaced(t *testing.T) {
	validGame := gameFactory()
	response, err := HandleCommand(validGame, "RIGHT")

	if err == nil {
		t.Fatal("expected error to be present, but got nil")
	}
	if response != nil {
		t.Fatalf("expected no response, got %s", *response)
	}
}
