package game

import (
	"fmt"

	"github.com/cfranklin11/toy-robot/internal/command"
	"github.com/cfranklin11/toy-robot/internal/robot"
	"github.com/cfranklin11/toy-robot/internal/table"
)

type Game struct {
	table table.Table
	robot robot.Robot
}

func (g *Game) executePlaceCommand(placeCommand command.PlaceCommand) (*string, error) {
	err := g.robot.Place(placeCommand.X, placeCommand.Y, placeCommand.Direction, g.table)
	if err != nil {
		return nil, err
	}

	response := ""
	return &response, nil
}

func (g *Game) executeCommand(command command.Command) (*string, error) {
	defaultResponse := ""

	switch command.Content {
	case "REPORT":
		return g.robot.Report()
	case "MOVE":
		err := g.robot.Move(g.table)
		if err != nil {
			return nil, err
		}

		return &defaultResponse, nil
	case "LEFT":
		err := g.robot.TurnLeft()
		if err != nil {
			return nil, err
		}

		return &defaultResponse, nil
	case "RIGHT":
		err := g.robot.TurnRight()
		if err != nil {
			return nil, err
		}

		return &defaultResponse, nil
	default:
		return &defaultResponse, fmt.Errorf("Unrecognized command %s", command.Content)
	}
}

func BuildGame(table table.Table, robot robot.Robot) (*Game, error) {
	return &Game{table: table, robot: robot}, nil
}

func StartGame() (*Game, error) {
	table, err := table.BuildTable()
	if err != nil {
		return nil, err
	}

	robot, err := robot.BuildRobot()
	if err != nil {
		return nil, err
	}

	return BuildGame(*table, *robot)
}

func HandleCommand(game *Game, input string) (*string, error) {
	if command.IsPlaceCommand(input) {
		command, err := command.BuildPlaceCommand(input)
		if err != nil {
			return nil, err
		}

		return game.executePlaceCommand(*command)
	}

	command, err := command.BuildCommand(input)
	if err != nil {
		return nil, err
	}

	return game.executeCommand(*command)
}
