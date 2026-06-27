package robot

import (
	"fmt"
	"testing"

	"github.com/cfranklin11/toy-robot/internal/command"
	"github.com/cfranklin11/toy-robot/internal/table"
)

func TestBuildRobot(t *testing.T) {
	robot, err := BuildRobot()

	if err != nil {
		t.Fatalf("expected error to be nil, got %v", err)
	}
	if robot == nil {
		t.Fatal("expected robot to be present, but got nil")
	}
}

func TestPlace_validCoordinates(t *testing.T) {
	validTable, _ := table.BuildTable(5, 5)
	x := 1
	y := 2
	direction := "SOUTH"
	placeString := fmt.Sprintf("PLACE %d, %d, %s", x, y, direction)
	validPlaceCommand, _ := command.BuildPlaceCommand(placeString)
	robot, _ := BuildRobot()
	err := robot.Place(*validTable, *validPlaceCommand)

	if err != nil {
		t.Fatalf("expected no error, got %v", err)
	}
	if robot.X.Value != x {
		t.Fatalf("expected X-coordinate to be %d, got %d", x, robot.X.Value)
	}
	if robot.Y.Value != y {
		t.Fatalf("expected Y-coordinate to be %d, got %d", y, robot.Y.Value)
	}
	if robot.Direction.Value != direction {
		t.Fatalf("expected direction to be %s, got %s", direction, robot.Direction.Value)
	}
}

func TestPlace_largeCoordinate(t *testing.T) {
	validTable, _ := table.BuildTable(5, 5)
	x := 7
	y := 2
	direction := "SOUTH"
	placeString := fmt.Sprintf("PLACE %d, %d, %s", x, y, direction)
	validPlaceCommand, _ := command.BuildPlaceCommand(placeString)
	robot, _ := BuildRobot()
	err := robot.Place(*validTable, *validPlaceCommand)

	if err == nil {
		t.Fatal("expected an error, got nil")
	}
	if robot.X != nil {
		t.Fatalf("expected X-coordinate to be nil, got %v", robot.X)
	}
	if robot.Y != nil {
		t.Fatalf("expected Y-coordinate to be nil, got %v", robot.Y)
	}
	if robot.Direction != nil {
		t.Fatalf("expected direction to be nil, got %s", robot.Direction)
	}
}

func TestPlace_zeroCoordinate(t *testing.T) {
	validTable, _ := table.BuildTable(5, 5)
	x := 0
	y := 2
	direction := "SOUTH"
	placeString := fmt.Sprintf("PLACE %d, %d, %s", x, y, direction)
	validPlaceCommand, _ := command.BuildPlaceCommand(placeString)
	robot, _ := BuildRobot()
	err := robot.Place(*validTable, *validPlaceCommand)

	if err != nil {
		t.Fatalf("expected no error, got %v", err)
	}
	if robot.X.Value != x {
		t.Fatalf("expected X-coordinate to be %d, got %d", x, robot.X.Value)
	}
	if robot.Y.Value != y {
		t.Fatalf("expected Y-coordinate to be %d, got %d", y, robot.Y.Value)
	}
	if robot.Direction.Value != direction {
		t.Fatalf("expected direction to be %s, got %s", direction, robot.Direction.Value)
	}
}
