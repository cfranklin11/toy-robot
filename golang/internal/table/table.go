package table

import (
	"fmt"

	"github.com/cfranklin11/toy-robot/internal/placement"
)

type Dimension struct {
	Measurement int
}

const minimumMeasurement int = 1

func buildDimension(measurement int) (*Dimension, error) {
	if measurement < minimumMeasurement {
		return nil, fmt.Errorf("dimension must have a measurement > 0")
	}

	return &Dimension{Measurement: measurement}, nil
}

const minimumCoordinate = 0

type Table struct {
	Width  Dimension
	Height Dimension
}

func (t Table) Contains(x placement.Coordinate, y placement.Coordinate) bool {
	return minimumCoordinate <= x.Value &&
		x.Value <= t.Width.Measurement &&
		minimumCoordinate <= y.Value &&
		y.Value <= t.Height.Measurement
}

const validWidthMeasurement int = 5

var validWidth Dimension = Dimension{Measurement: validWidthMeasurement}

const validHeightMeasurement int = 5

var validHeight Dimension = Dimension{Measurement: validHeightMeasurement}

func BuildTable(widthMeasurement, heightMeasurement int) (*Table, error) {
	width, err := buildDimension(widthMeasurement)
	if err != nil {
		return nil, err
	}

	height, err := buildDimension(heightMeasurement)
	if err != nil {
		return nil, err
	}

	if *width != validWidth {
		return nil, fmt.Errorf("Table width must be %d", validWidth)
	}

	if *height != validHeight {
		return nil, fmt.Errorf("Table height must be %d", validHeight)
	}

	return &Table{Width: *width, Height: *height}, nil
}
