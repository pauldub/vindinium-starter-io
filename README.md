vindinium-starter-io
====================

A starter pack for the game http://vindinium.org for the Io programming language.

## TODO

- Properly handle errors when trying to parse JSON but the game is finished.
- Write some docs.
- Write some tests.

## Usage

1. Clone the repository.
2. Use the `Vindi` object.

The library implements `Vindi` object should be the entry point, it allows one to create training or arena games with the `newGame(key)` method.

This returns a `Vindi Game` object which can be used to query the current game state, it reads the heroes, the board and the tiles into their own objects.

Call the `Vindi Game` object's `move(direction)` method to submit your move for the current  turn, this methods returns a new game §

You can change the mode by changing the `Vindi` `api` slot, for example:

```io
Vindi api = Vindi arena
```

## Example

A really useless bot -- only staying in place -- can be created like this:

```io
Bot := Object clone do(
	key := "my-bot-key"

	start := method(
		game := Vindi newGame(self key)
		while(game finished == "false",
			game = game move("Stay")
		)
	)
