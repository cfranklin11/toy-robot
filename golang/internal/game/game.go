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
	table table.Table
	robot robot.Robot
}

func (g *Game) executePlaceCommand(placeCommand command.PlaceCommand) (*string, error) {
	if !g.table.Contains(placeCommand.X, placeCommand.Y) {
		return nil, fmt.Errorf(
			"Given coordinates do not fit on table with dimensions %s",
			g.table.Dimensions(),
		)
	}
	g.robot.Place(placeCommand)

	response := ""
	return &response, nil
}

func (g *Game) executeCommand(command command.Command) (*string, error) {
	switch command.Content {
	case "REPORT":
		return g.robot.Report()
	default:
		response := ""
		return &response, fmt.Errorf("Unrecognized command %s", command.Content)
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
