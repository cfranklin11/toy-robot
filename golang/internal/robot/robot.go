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

	report := fmt.Sprintf("%s, %s, %s", r.x.ToString(), r.y.ToString(), r.direction.ToString())
	return &report, nil
}

func (r *Robot) ForwardX() (*placement.Coordinate, error) {
	if !r.isPlaced() {
		return nil, fmt.Errorf("Robot must be placed in order to have an x-coordinate")
	}

	switch r.direction.ToString() {
	case "NORTH":
		return r.x, nil
	case "SOUTH":
		return r.x, nil
	case "EAST":
		return r.x.Add(1)
	case "WEST":
		return r.x.Subtract(1)
	default:
		return nil, fmt.Errorf("Unknown direction %v", r.direction)
	}
}

func (r *Robot) ForwardY() (*placement.Coordinate, error) {
	if !r.isPlaced() {
		return nil, fmt.Errorf("Robot must be placed in order to have an x-coordinate")
	}

	switch r.direction.ToString() {
	case "NORTH":
		return r.y.Add(1)
	case "SOUTH":
		return r.y.Subtract(1)
	case "EAST":
		return r.y, nil
	case "WEST":
		return r.y, nil
	default:
		return nil, fmt.Errorf("Unknown direction %v", r.direction)
	}
}

func (r *Robot) Move() error {
	forwardX, err := r.ForwardX()
	if err != nil {
		return err
	}

	forwardY, err := r.ForwardY()
	if err != nil {
		return err
	}
	r.x = forwardX
	r.y = forwardY
	return nil
}

func BuildRobot() (*Robot, error) {
	return &Robot{}, nil
}
