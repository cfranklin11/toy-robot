package game

import (
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

func (g Game) ExecuteCommand(command command.Command) error {
	return nil
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

func HandleCommand(game Game, input string) error {
	command, err := command.BuildCommand(input)
	if err != nil {
		return err
	}

	return game.ExecuteCommand(*command)
}
