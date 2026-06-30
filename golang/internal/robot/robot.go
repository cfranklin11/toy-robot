package robot

import (
	"fmt"

	"github.com/cfranklin11/toy-robot/internal/placement"
	"github.com/cfranklin11/toy-robot/internal/table"
)

type Robot struct {
	x         *placement.Coordinate
	y         *placement.Coordinate
	direction *placement.Direction
}

func (r *Robot) Place(x placement.Coordinate, y placement.Coordinate, direction placement.Direction, table table.Table) error {
	if !table.Contains(x, y) {
		return fmt.Errorf(
			"Given coordinates do not fit on table with dimensions %s",
			table.Dimensions(),
		)
	}

	r.x = &x
	r.y = &y
	r.direction = &direction
	return nil
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

func (r *Robot) Move(table table.Table) error {
	forwardX, err := r.ForwardX()
	if err != nil {
		return err
	}

	forwardY, err := r.ForwardY()
	if err != nil {
		return err
	}

	if !table.Contains(*forwardX, *forwardY) {
		return fmt.Errorf("Robot is at the edge of the table and cannot move")
	}

	r.x = forwardX
	r.y = forwardY
	return nil
}

func (r *Robot) TurnLeft() error {
	turnLeftMap := map[placement.Direction]placement.Direction{
		placement.Directions["NORTH"]: placement.Directions["WEST"],
		placement.Directions["SOUTH"]: placement.Directions["EAST"],
		placement.Directions["EAST"]:  placement.Directions["NORTH"],
		placement.Directions["WEST"]:  placement.Directions["SOUTH"],
	}
	if !r.isPlaced() {
		return fmt.Errorf("Robot must be placed in order to turn left")
	}

	newDirection := turnLeftMap[*r.direction]
	r.direction = &newDirection
	return nil
}

func (r *Robot) TurnRight() error {
	turnLeftMap := map[placement.Direction]placement.Direction{
		placement.Directions["NORTH"]: placement.Directions["EAST"],
		placement.Directions["SOUTH"]: placement.Directions["WEST"],
		placement.Directions["EAST"]:  placement.Directions["SOUTH"],
		placement.Directions["WEST"]:  placement.Directions["NORTH"],
	}
	if !r.isPlaced() {
		return fmt.Errorf("Robot must be placed in order to turn left")
	}

	newDirection := turnLeftMap[*r.direction]
	r.direction = &newDirection
	return nil
}

func BuildRobot() (*Robot, error) {
	return &Robot{}, nil
}
