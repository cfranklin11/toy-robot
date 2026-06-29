package placement

import (
	"testing"
)

func TestBuildCoordinate_positiveNumber(t *testing.T) {
	coordinate, err := BuildCoordinate("42")

	if err != nil {
		t.Fatalf("expected err to be nil, got %v", err)
	}
	if coordinate == nil {
		t.Fatal("expected coordinate to be present, got nil")
	}
}

func TestBuildCoordinate_negativeNumber(t *testing.T) {
	coordinate, err := BuildCoordinate("-42")

	if err == nil {
		t.Fatal("expected err to be present, got nil")
	}
	if coordinate != nil {
		t.Fatalf("expected coordinate to be nil, got %v", coordinate)
	}
}

func TestBuildCoordinate_zero(t *testing.T) {
	coordinate, err := BuildCoordinate("0")

	if err != nil {
		t.Fatalf("expected err to be nil, got %v", err)
	}
	if coordinate == nil {
		t.Fatal("expected coordinate to be present, got nil")
	}
}

func TestBuildCoordinate_notNumeric(t *testing.T) {
	coordinate, err := BuildCoordinate("stuff")

	if err == nil {
		t.Fatal("expected err to be present, got nil")
	}
	if coordinate != nil {
		t.Fatalf("expected coordinate to be nil, got %v", coordinate)
	}
}

func TestBuildDirection_validValue(t *testing.T) {
	direction, err := BuildDirection("NORTH")

	if err != nil {
		t.Fatalf("expected err to be nil, got %v", err)
	}
	if direction == nil {
		t.Fatal("expected direction to be present, got nil")
	}
}

func TestBuildCoordinate_invalidValue(t *testing.T) {
	direction, err := BuildDirection("STUFF")

	if err == nil {
		t.Fatal("expected err to be present, got nil")
	}
	if direction != nil {
		t.Fatalf("expected direction to be nil, got %v", direction)
	}
}

func TestCoordinateToString(t *testing.T) {
	coordinate, _ := BuildCoordinate("5")
	coordinateString := coordinate.ToString()

	if coordinateString != "5" {
		t.Fatalf("expected coordinate string to be '5', got %s", coordinateString)
	}
}

func TestDirectionToString(t *testing.T) {
	direction, _ := BuildDirection("NORTH")
	directionString := direction.ToString()

	if directionString != "NORTH" {
		t.Fatalf("expected direction string to be 'NORTH', got %s", directionString)
	}
}

func TestCoordinateGreaterThanOrEqualTo_whenGreater(t *testing.T) {
	coordinate, _ := BuildCoordinate("5")
	lesserCoordinate, _ := BuildCoordinate("2")
	isGTE := coordinate.GreaterThanOrEqualTo(*lesserCoordinate)

	if isGTE == false {
		t.Fatalf("expected coordinate to be greater than or equal, got false")
	}
}

func TestCoordinateGreaterThanOrEqualTo_whenEqual(t *testing.T) {
	coordinate, _ := BuildCoordinate("5")
	equalCoordinate, _ := BuildCoordinate("5")
	isGTE := coordinate.GreaterThanOrEqualTo(*equalCoordinate)

	if isGTE == false {
		t.Fatalf("expected coordinate to be greater than or equal, got false")
	}
}

func TestCoordinateGreaterThanOrEqualTo_whenLesser(t *testing.T) {
	coordinate, _ := BuildCoordinate("5")
	greaterCoordinate, _ := BuildCoordinate("8")
	isGTE := coordinate.GreaterThanOrEqualTo(*greaterCoordinate)

	if isGTE == true {
		t.Fatalf("expected coordinate not to be greater than or equal, got true")
	}
}

func TestCoordinateAdd(t *testing.T) {
	coordinate, _ := BuildCoordinate("5")
	addedCoordinate, err := coordinate.Add(2)
	expectedCoordinate, _ := BuildCoordinate("7")

	if err != nil {
		t.Fatalf("expected err to be nil, got %v", err)
	}
	if *addedCoordinate != *expectedCoordinate {
		t.Fatalf("expected coordinate to be 7, got %v", addedCoordinate)
	}
}

func TestCoordinateSubtract(t *testing.T) {
	coordinate, _ := BuildCoordinate("5")
	addedCoordinate, err := coordinate.Subtract(2)
	expectedCoordinate, _ := BuildCoordinate("3")

	if err != nil {
		t.Fatalf("expected err to be nil, got %v", err)
	}
	if *addedCoordinate != *expectedCoordinate {
		t.Fatalf("expected coordinate to be 3, got %v", addedCoordinate)
	}
}
