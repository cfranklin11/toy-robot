package robot

import (
	"fmt"
	"testing"

	"github.com/cfranklin11/toy-robot/internal/command"
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
