package robot

import (
	"fmt"

	"github.com/cfranklin11/toy-robot/internal/command"
	"github.com/cfranklin11/toy-robot/internal/placement"
)

type Robot struct {
	x         *placement.Coordinate
	y         *placement.Coordinate
	direction *placement.Direction
}

func (r *Robot) Place(command command.PlaceCommand) {
	r.x = &command.X
	r.y = &command.Y
	r.direction = &command.Direction
}

func (r *Robot) isPlaced() bool {
	return r.x != nil && r.y != nil && r.direction != nil
}

func (r *Robot) Report() (*string, error) {
	if !r.isPlaced() {
		return nil, fmt.Errorf("Robot must be placed in order to report")
	}

	report := fmt.Sprintf("%d, %d, %s", r.x.Value, r.y.Value, r.direction.Value)
	return &report, nil
}

func BuildRobot() (*Robot, error) {
	return &Robot{}, nil
}
