package game

import (
	"github.com/cfranklin11/toy-robot/internal/command"
	"github.com/cfranklin11/toy-robot/internal/table"
)

type Game struct {
	Table table.Table
}

func (g Game) ExecuteCommand(command command.Command) command.Command {
	return command
}

func BuildGame(width, height int) (*Game, error) {
	table, err := table.BuildTable(width, height)
	if err != nil {
		return nil, err
	}

	return &Game{Table: *table}, nil
}
