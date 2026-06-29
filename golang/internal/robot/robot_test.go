package robot

import (
	"fmt"
	"testing"

	"github.com/cfranklin11/toy-robot/internal/command"
	"github.com/cfranklin11/toy-robot/internal/placement"
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
	x := 1
	y := 2
	direction := "SOUTH"
	placeString := fmt.Sprintf("%d, %d, %s", x, y, direction)
	placeCommandString := fmt.Sprintf("PLACE %s", placeString)
	validPlaceCommand, _ := command.BuildPlaceCommand(placeCommandString)
	robot, _ := BuildRobot()
	robot.Place(*validPlaceCommand)

	report, _ := robot.Report()
	if *report != placeString {
		t.Fatalf("expected robot to be placed at %s, got %s", placeString, *report)
	}
}

func TestReport_whenPlaced(t *testing.T) {
	x := 0
	y := 2
	direction := "SOUTH"
	placeString := fmt.Sprintf("PLACE %d, %d, %s", x, y, direction)
	validPlaceCommand, _ := command.BuildPlaceCommand(placeString)
	robot, _ := BuildRobot()
	robot.Place(*validPlaceCommand)
	report, err := robot.Report()

	if err != nil {
		t.Fatalf("expected no error, got %v", err)
	}

	if *report != "0, 2, SOUTH" {
		t.Fatalf("expected report to be 0, 2, SOUTH, got %v", report)
	}
}

func TestReport_whenNotPlaced(t *testing.T) {
	robot, _ := BuildRobot()
	report, err := robot.Report()

	if err == nil {
		t.Fatal("expected error to be present, got nil")
	}

	if report != nil {
		t.Fatalf("expected report to be nil, got %v", report)
	}
}

func TestForwardX_whenNotPlaced(t *testing.T) {
	robot, _ := BuildRobot()
	coordinate, err := robot.ForwardX()

	if err == nil {
		t.Fatal("expected error to be present, got nil")
	}

	if coordinate != nil {
		t.Fatalf("expected report to be nil, got %v", coordinate)
	}
}

func TestForwardX_facingSouth(t *testing.T) {
	x := 4
	y := 1
	direction := "SOUTH"
	placeString := fmt.Sprintf("PLACE %d, %d, %s", x, y, direction)
	validPlaceCommand, _ := command.BuildPlaceCommand(placeString)
	robot, _ := BuildRobot()
	robot.Place(*validPlaceCommand)
	coordinate, err := robot.ForwardX()
	expectedCoordinate, _ := placement.BuildCoordinate("4")

	if err != nil {
		t.Fatalf("expected no error, got %v", err)
	}

	if *coordinate != *expectedCoordinate {
		t.Fatalf("expected coordinate to be 4, got %v", coordinate)
	}
}

func TestForwardX_facingNorth(t *testing.T) {
	x := 4
	y := 1
	direction := "NORTH"
	placeString := fmt.Sprintf("PLACE %d, %d, %s", x, y, direction)
	validPlaceCommand, _ := command.BuildPlaceCommand(placeString)
	robot, _ := BuildRobot()
	robot.Place(*validPlaceCommand)
	coordinate, err := robot.ForwardX()
	expectedCoordinate, _ := placement.BuildCoordinate("4")

	if err != nil {
		t.Fatalf("expected no error, got %v", err)
	}

	if *coordinate != *expectedCoordinate {
		t.Fatalf("expected coordinate to be 4, got %v", coordinate)
	}
}

func TestForwardX_facingEast(t *testing.T) {
	x := 4
	y := 1
	direction := "EAST"
	placeString := fmt.Sprintf("PLACE %d, %d, %s", x, y, direction)
	validPlaceCommand, _ := command.BuildPlaceCommand(placeString)
	robot, _ := BuildRobot()
	robot.Place(*validPlaceCommand)
	coordinate, err := robot.ForwardX()
	expectedCoordinate, _ := placement.BuildCoordinate("5")

	if err != nil {
		t.Fatalf("expected no error, got %v", err)
	}

	if *coordinate != *expectedCoordinate {
		t.Fatalf("expected coordinate to be 5, got %v", coordinate)
	}
}

func TestForwardX_facingWest(t *testing.T) {
	x := 4
	y := 1
	direction := "WEST"
	placeString := fmt.Sprintf("PLACE %d, %d, %s", x, y, direction)
	validPlaceCommand, _ := command.BuildPlaceCommand(placeString)
	robot, _ := BuildRobot()
	robot.Place(*validPlaceCommand)
	coordinate, err := robot.ForwardX()
	expectedCoordinate, _ := placement.BuildCoordinate("3")

	if err != nil {
		t.Fatalf("expected no error, got %v", err)
	}

	if *coordinate != *expectedCoordinate {
		t.Fatalf("expected coordinate to be 3, got %v", coordinate)
	}
}

func TestForwardY_whenNotPlaced(t *testing.T) {
	robot, _ := BuildRobot()
	coordinate, err := robot.ForwardY()

	if err == nil {
		t.Fatal("expected error to be present, got nil")
	}

	if coordinate != nil {
		t.Fatalf("expected report to be nil, got %v", coordinate)
	}
}

func TestForwardY_facingSouth(t *testing.T) {
	x := 4
	y := 1
	direction := "SOUTH"
	placeString := fmt.Sprintf("PLACE %d, %d, %s", x, y, direction)
	validPlaceCommand, _ := command.BuildPlaceCommand(placeString)
	robot, _ := BuildRobot()
	robot.Place(*validPlaceCommand)
	coordinate, err := robot.ForwardY()
	expectedCoordinate, _ := placement.BuildCoordinate("0")

	if err != nil {
		t.Fatalf("expected no error, got %v", err)
	}

	if *coordinate != *expectedCoordinate {
		t.Fatalf("expected coordinate to be 0, got %v", coordinate)
	}
}

func TestForwardY_facingNorth(t *testing.T) {
	x := 4
	y := 1
	direction := "NORTH"
	placeString := fmt.Sprintf("PLACE %d, %d, %s", x, y, direction)
	validPlaceCommand, _ := command.BuildPlaceCommand(placeString)
	robot, _ := BuildRobot()
	robot.Place(*validPlaceCommand)
	coordinate, err := robot.ForwardY()
	expectedCoordinate, _ := placement.BuildCoordinate("2")

	if err != nil {
		t.Fatalf("expected no error, got %v", err)
	}

	if *coordinate != *expectedCoordinate {
		t.Fatalf("expected coordinate to be 2, got %v", coordinate)
	}
}

func TestForwardY_facingEast(t *testing.T) {
	x := 4
	y := 1
	direction := "EAST"
	placeString := fmt.Sprintf("PLACE %d, %d, %s", x, y, direction)
	validPlaceCommand, _ := command.BuildPlaceCommand(placeString)
	robot, _ := BuildRobot()
	robot.Place(*validPlaceCommand)
	coordinate, err := robot.ForwardY()
	expectedCoordinate, _ := placement.BuildCoordinate("1")

	if err != nil {
		t.Fatalf("expected no error, got %v", err)
	}

	if *coordinate != *expectedCoordinate {
		t.Fatalf("expected coordinate to be 1, got %v", coordinate)
	}
}

func TestForwardY_facingWest(t *testing.T) {
	x := 4
	y := 1
	direction := "WEST"
	placeString := fmt.Sprintf("PLACE %d, %d, %s", x, y, direction)
	validPlaceCommand, _ := command.BuildPlaceCommand(placeString)
	robot, _ := BuildRobot()
	robot.Place(*validPlaceCommand)
	coordinate, err := robot.ForwardY()
	expectedCoordinate, _ := placement.BuildCoordinate("1")

	if err != nil {
		t.Fatalf("expected no error, got %v", err)
	}

	if *coordinate != *expectedCoordinate {
		t.Fatalf("expected coordinate to be 1, got %v", coordinate)
	}
}

func TestMove_whenNotPlaced(t *testing.T) {
	robot, _ := BuildRobot()
	err := robot.Move()

	if err == nil {
		t.Fatal("expected error to be present, got nil")
	}
}

func TestMove_whenPlaced(t *testing.T) {
	x := 4
	y := 1
	direction := "SOUTH"
	placeString := fmt.Sprintf("PLACE %d, %d, %s", x, y, direction)
	validPlaceCommand, _ := command.BuildPlaceCommand(placeString)
	robot, _ := BuildRobot()
	robot.Place(*validPlaceCommand)
	err := robot.Move()
	report, _ := robot.Report()

	if err != nil {
		t.Fatalf("expected no error, got %v", err)
	}

	if *report != "4, 0, SOUTH" {
		t.Fatalf("expected placement to be '4, 0, SOUTH', got %s", *report)
	}
}
