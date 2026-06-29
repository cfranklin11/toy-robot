package placement

import (
	"fmt"
	"strconv"
)

type Coordinate struct {
	value int
}

func (c *Coordinate) ToString() string {
	return strconv.Itoa(c.value)
}

func (c *Coordinate) GreaterThanOrEqualTo(otherCoordinate Coordinate) bool {
	return c.value >= otherCoordinate.value
}

func (c *Coordinate) Add(value int) (*Coordinate, error) {
	sum := c.value + value
	return BuildCoordinate(strconv.Itoa(sum))
}

func (c *Coordinate) Subtract(value int) (*Coordinate, error) {
	sum := c.value - value
	return BuildCoordinate(strconv.Itoa(sum))
}

type Direction struct {
	value string
}

func (d *Direction) ToString() string {
	return string(d.value)
}

func BuildCoordinate(strValue string) (*Coordinate, error) {
	intValue, err := strconv.Atoi(strValue)
	if err != nil {
		return nil, err
	}
	if intValue < 0 {
		return nil, fmt.Errorf("Coordinate values must be greater than or equal to 0")
	}

	return &Coordinate{value: intValue}, nil
}

var validDirections = map[string]bool{
	"NORTH": true,
	"SOUTH": true,
	"EAST":  true,
	"WEST":  true,
}

func BuildDirection(value string) (*Direction, error) {
	isValidDirection := validDirections[value]
	if !isValidDirection {
		return nil, fmt.Errorf("%s is not a valid direction", value)
	}

	return &Direction{value: value}, nil
}
