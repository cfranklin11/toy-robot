package command

import (
	"fmt"
	"regexp"
	"strings"

	"github.com/cfranklin11/toy-robot/internal/placement"
)

type Command struct {
	Content string
}

type PlaceCommand struct {
	X         placement.Coordinate
	Y         placement.Coordinate
	Direction placement.Direction
}

func BuildPlaceCommand(content string) (*PlaceCommand, error) {
	const xMatchIndex = 1
	const yMatchIndex = 2
	const directionMatchIndex = 3
	re := regexp.MustCompile(`PLACE (\d+), (\d+), (\w+)`)
	matches := re.FindStringSubmatch(content)
	if len(matches) == 0 {
		return nil, fmt.Errorf("%s is not a valid PLACE command", content)
	}

	xString := matches[xMatchIndex]
	xCoordinate, err := placement.BuildCoordinate(xString)
	if err != nil {
		return nil, err
	}

	yString := matches[yMatchIndex]
	yCoordinate, err := placement.BuildCoordinate(yString)
	if err != nil {
		return nil, err
	}

	directionString := matches[directionMatchIndex]
	direction, err := placement.BuildDirection(directionString)
	if err != nil {
		return nil, err
	}

	return &PlaceCommand{X: *xCoordinate, Y: *yCoordinate, Direction: *direction}, nil
}

func BuildCommand(content string) (*Command, error) {
	validContent := map[string]bool{
		"MOVE":   true,
		"LEFT":   true,
		"RIGHT":  true,
		"REPORT": true,
	}
	isValidContent := validContent[content]
	if !isValidContent {
		return nil, fmt.Errorf("%s is not a valid command", content)
	}

	return &Command{Content: content}, nil
}

func IsPlaceCommand(input string) bool {
	return strings.HasPrefix(input, "PLACE")
}
