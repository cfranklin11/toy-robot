package table

import (
	"testing"

	"github.com/cfranklin11/toy-robot/internal/placement"
)

func TestBuildTable_validDimensions(t *testing.T) {
	table, err := BuildTable(5, 5)

	if err != nil {
		t.Fatalf("expected no error, got %v", err)
	}
	if table == nil {
		t.Fatalf("expected Table to be present, got %v", table)
	}
	if table.Width.Measurement != 5 || table.Height.Measurement != 5 {
		t.Fatalf("expected 5x5, got %dx%d", table.Width, table.Height)
	}
}

func TestBuildTable_invalidMeasurement(t *testing.T) {
	table, err := BuildTable(-1, 5)

	if err == nil {
		t.Fatal("expected an error, got nil")
	}
	if table != nil {
		t.Fatalf("expected no table, got %v", table)
	}
}

func TestBuildTable_invalidWidth(t *testing.T) {
	table, err := BuildTable(6, 5)

	if err == nil {
		t.Fatal("expected an error, got nil")
	}
	if table != nil {
		t.Fatalf("expected no table, got %v", table)
	}
}

func TestBuildTable_invalidHeight(t *testing.T) {
	table, err := BuildTable(5, 6)

	if err == nil {
		t.Fatal("expected an error, got nil")
	}
	if table != nil {
		t.Fatalf("expected no table, got %v", table)
	}
}

func TestContains_containedCoordinates(t *testing.T) {
	validTable, _ := BuildTable(5, 5)
	xCoordinate, _ := placement.BuildCoordinate("2")
	yCoordinate, _ := placement.BuildCoordinate("4")
	isContained := validTable.Contains(*xCoordinate, *yCoordinate)

	if isContained == false {
		t.Fatal("expected the coordinates to be inside the table, got false")
	}
}

func TestContains_uncontainedCoordinates(t *testing.T) {
	validTable, _ := BuildTable(5, 5)
	xCoordinate, _ := placement.BuildCoordinate("8")
	yCoordinate, _ := placement.BuildCoordinate("4")
	isContained := validTable.Contains(*xCoordinate, *yCoordinate)

	if isContained == true {
		t.Fatal("expected the coordinates not to be inside the table, got true")
	}
}
