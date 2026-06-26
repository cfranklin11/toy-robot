package table

import (
	"testing"
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
