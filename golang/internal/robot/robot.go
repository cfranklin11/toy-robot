package robot

import (
	"fmt"

	"github.com/cfranklin11/toy-robot/internal/command"
	"github.com/cfranklin11/toy-robot/internal/placement"
	"github.com/cfranklin11/toy-robot/internal/table"
)

type Robot struct {
	X         *placement.Coordinate
	Y         *placement.Coordinate
	Direction *placement.Direction
}

func (r *Robot) Place(table table.Table, command command.PlaceCommand) error {
	if !table.Contains(command.X, command.Y) {
		return fmt.Errorf(
			"Given coordinates do not fit in table with dimensions %d x %d",
			table.Width.Measurement,
			table.Height.Measurement,
		)
	}

	r.X = &command.X
	r.Y = &command.Y
	r.Direction = &command.Direction
	return nil
}

func (r *Robot) isPlaced() bool {
	return r.X != nil && r.Y != nil && r.Direction != nil
}

func (r *Robot) Report() (*string, error) {
	if !r.isPlaced() {
		return nil, fmt.Errorf("Robot must be placed in order to report")
	}

	report := fmt.Sprintf("%d, %d, %s", r.X.Value, r.Y.Value, r.Direction.Value)
	return &report, nil
}

func BuildRobot() (*Robot, error) {
	return &Robot{}, nil
}
