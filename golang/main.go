package main

import (
	"bufio"
	"fmt"
	"os"
	"strings"

	"github.com/cfranklin11/toy-robot/internal/command"
	"github.com/cfranklin11/toy-robot/internal/game"
)

const tableWidth int = 5
const tableHeight int = 5

func requestCommand() {
	fmt.Println("Please enter a command: PLACE, MOVE, LEFT, RIGHT, or REPORT")
}

func main() {
	fmt.Println("Welcome to Toy Robot!")
	game, err := game.BuildGame(tableWidth, tableHeight)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error: %s\nExiting game.\n", err)
		return
	}

	requestCommand()
	scanner := bufio.NewScanner(os.Stdin)
	for scanner.Scan() {
		input := strings.TrimSpace(scanner.Text())
		command, err := command.BuildCommand(input)
		if err != nil {
			fmt.Fprintf(os.Stderr, "Error: %s\n", err)
		} else {
			game.ExecuteCommand(*command)
		}

		requestCommand()
	}
	fmt.Fprintf(os.Stderr, "%s", scanner.Err().Error())
}
