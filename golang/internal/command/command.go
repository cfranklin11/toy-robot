package command

import "fmt"

type Command struct {
	Content string
}

var validContent = map[string]bool{
	"PLACE":  true,
	"MOVE":   true,
	"LEFT":   true,
	"RIGHT":  true,
	"REPORT": true,
}

func BuildCommand(content string) (*Command, error) {
	isValidContent := validContent[content]
	if !isValidContent {
		return nil, fmt.Errorf("%s is not a valid command", content)
	}

	return &Command{Content: content}, nil
}
