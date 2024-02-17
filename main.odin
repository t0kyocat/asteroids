package main

import "core:fmt"
import "core:math"
import "Input"
import rl "vendor:raylib"

laser:= rl.LoadSound("sounds/laser.wav")
hitship:= rl.LoadSound("sounds/hitship.wav")
hitast:= rl.LoadSound("sounds/hitast.wav")

main :: proc() {

    rl.InitAudioDevice()



    game : Game
	InitGame(&game)
    defer CloseGame()
    game.state.screen = .MENU
	gameloop: for GameIsRunning(Keyboard.ESCAPE) {

        GameUpdate(&game, GetDeltaTime())
        GameDraw(&game)    
	}
    rl.CloseAudioDevice()

}



