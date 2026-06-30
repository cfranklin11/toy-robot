package table

import (
	"testing"

	"github.com/cfranklin11/toy-robot/internal/placement"
)

func TestBuildTable(t *testing.T) {
	table, err := BuildTable()

	if err != nil {
		t.Fatalf("expected no error, got %v", err)
	}
	if table == nil {
		t.Fatalf("expected Table to be present, got %v", table)
	}
}

func TestContains_containedCoordinates(t *testing.T) {
	validTable, _ := BuildTable()
	xCoordinate, _ := placement.BuildCoordinate("2")
	yCoordinate, _ := placement.BuildCoordinate("4")
	isContained := validTable.Contains(*xCoordinate, *yCoordinate)

	if isContained == false {
		t.Fatal("expected the coordinates to be inside the table, got false")
	}
}

func TestContains_uncontainedCoordinates(t *testing.T) {
	validTable, _ := BuildTable()
	xCoordinate, _ := placement.BuildCoordinate("8")
	yCoordinate, _ := placement.BuildCoordinate("4")
	isContained := validTable.Contains(*xCoordinate, *yCoordinate)

	if isContained == true {
		t.Fatal("expected the coordinates not to be inside the table, got true")
	}
}

func TestDimensions(t *testing.T) {
	validTable, _ := BuildTable()
	dimensions := validTable.Dimensions()

	if dimensions != "5 x 5" {
		t.Fatalf("expected dimensions to be '5 x 5', got %s", dimensions)
	}
}
