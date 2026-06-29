package main

import (
	"bufio"
	"fmt"
	"os"
	"strings"

	"github.com/cfranklin11/toy-robot/internal/game"
)

func requestCommand() {
	fmt.Println("Please enter a command: PLACE, MOVE, LEFT, RIGHT, or REPORT")
}

func main() {
	fmt.Println("Welcome to Toy Robot!")
	currentGame, err := game.StartGame()
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error: %s\nExiting game.\n", err.Error())
		return
	}
	requestCommand()

	scanner := bufio.NewScanner(os.Stdin)
	for scanner.Scan() {
		input := strings.TrimSpace(scanner.Text())
		response, err := game.HandleCommand(currentGame, input)
		if err != nil {
			fmt.Fprintf(os.Stderr, "Error: %s\n\n", err.Error())
		} else {
			fmt.Println(*response)
		}

		requestCommand()
	}
	err = scanner.Err()
	if err != nil {
		fmt.Fprintf(os.Stderr, "%s", err.Error())
	}
}
