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

func BuildRobot() (*Robot, error) {
	return &Robot{}, nil
}
