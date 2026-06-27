package placement

import (
	"fmt"
	"strconv"
)

type Coordinate struct {
	Value int
}

type Direction struct {
	Value string
}

func BuildCoordinate(strValue string) (*Coordinate, error) {
	intValue, err := strconv.Atoi(strValue)
	if err != nil {
		return nil, err
	}
	if intValue < 0 {
		return nil, fmt.Errorf("Coordinate values must be greater than or equal to 0")
	}

	return &Coordinate{Value: intValue}, nil
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

	return &Direction{Value: value}, nil
}
