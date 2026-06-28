package robot

import (
	"fmt"

	"github.com/cfranklin11/toy-robot/internal/command"
	"github.com/cfranklin11/toy-robot/internal/placement"
)

type Robot struct {
	X         *placement.Coordinate
	Y         *placement.Coordinate
	Direction *placement.Direction
}

func (r *Robot) Place(command command.PlaceCommand) {
	r.X = &command.X
	r.Y = &command.Y
	r.Direction = &command.Direction
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
