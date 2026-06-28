package table

import (
	"fmt"

	"github.com/cfranklin11/toy-robot/internal/placement"
)

type Table struct {
	minXCoordinate placement.Coordinate
	maxXCoordinate placement.Coordinate
	minYCoordinate placement.Coordinate
	maxYCoordinate placement.Coordinate
}

func (t Table) Contains(x placement.Coordinate, y placement.Coordinate) bool {
	return x.GreaterThanOrEqualTo(t.minXCoordinate) &&
		t.maxXCoordinate.GreaterThanOrEqualTo(x) &&
		y.GreaterThanOrEqualTo(t.minYCoordinate) &&
		t.maxYCoordinate.GreaterThanOrEqualTo(y)
}

func (t Table) Dimensions() string {
	return fmt.Sprintf("%s x %s", t.maxXCoordinate.ToString(), t.maxYCoordinate.ToString())
}

const validMinX string = "0"
const validMaxX string = "5"
const validMinY string = "0"
const validMaxY string = "5"

func BuildTable() (*Table, error) {
	minXCoordinate, err := placement.BuildCoordinate(validMinX)
	if err != nil {
		return nil, err
	}

	maxXCoordinate, err := placement.BuildCoordinate(validMaxX)
	if err != nil {
		return nil, err
	}

	minYCoordinate, err := placement.BuildCoordinate(validMinY)
	if err != nil {
		return nil, err
	}

	maxYCoordinate, err := placement.BuildCoordinate(validMaxY)
	if err != nil {
		return nil, err
	}

	return &Table{minXCoordinate: *minXCoordinate, maxXCoordinate: *maxXCoordinate, minYCoordinate: *minYCoordinate, maxYCoordinate: *maxYCoordinate}, nil
}
