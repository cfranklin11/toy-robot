package game

import (
	"fmt"

	"github.com/cfranklin11/toy-robot/internal/command"
	"github.com/cfranklin11/toy-robot/internal/robot"
	"github.com/cfranklin11/toy-robot/internal/table"
)

const tableWidth int = 5
const tableHeight int = 5

type Game struct {
	Table table.Table
	Robot robot.Robot
}

func (g *Game) executePlaceCommand(placeCommand command.PlaceCommand) (*string, error) {
	err := g.Robot.Place(g.Table, placeCommand)
	if err != nil {
		return nil, err
	}

	response := ""
	return &response, nil
}

func (g *Game) executeCommand(command command.Command) (*string, error) {
	switch command.Content {
	case "REPORT":
		return g.Robot.Report()
	default:
		response := ""
		return &response, fmt.Errorf("Unrecognized command %s", command.Content)
	}
}

func BuildGame(table table.Table, robot robot.Robot) (*Game, error) {
	return &Game{Table: table, Robot: robot}, nil
}

func StartGame() (*Game, error) {
	table, err := table.BuildTable(tableWidth, tableHeight)
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
