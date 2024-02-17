package main

import rl "vendor:raylib"
import "core:math/rand"
import "core:math"
import "core:fmt"
import "core:os"
import "core:time"
import "core:sys/windows"
import "Input"


TITLE_SIZE : i32 = 80
TITLE :: "ASTEROIDS"
@(private="file") _alpha : u8 = 255
@(private="file") _alphabool1 : bool = true
@(private="file") _alphabool2 : bool = false
@(private="file") _rotation : f32 = 0


DrawTitle :: proc() {
    DrawTextCentered(rl.TextSubtext(TITLE, 0, i32(GetTime() / 0.1)), GetScreenCenter()-{0, 100}, TITLE_SIZE, {240,240,240,255})
    rl.DrawPoly(GetScreenCenter()+{300, -60}, 3, 20, _rotation, rl.WHITE)
}

DrawEnterToPlay :: proc() {
    DrawTextCentered("Press ENTER to play", GetScreenCenter()+{0,80}, 30, {240,240,240,_alpha})
}

UpdateTitle :: proc() {

    if _alphabool1 && _alpha > 0 {
        _alpha -= 5
        if _alpha <= 0 {
            _alphabool1 = false
            _alphabool2 = true
        } 
    }
    else if _alphabool2 && _alpha < 255 {
        _alpha +=5
         if _alpha >= 255 {
            _alphabool2 = false
            _alphabool1 = true
         }
    }
    _rotation+=60* rl.DEG2RAD

}

DrawDeadScreen :: proc(game: ^Game) {
    DrawTextCentered(rl.TextFormat("SCORE: %d", game.player.score),GetScreenCenter()-{0, 40}, 40, rl.BLUE)
    DrawTextCentered("YOU LOST", GetScreenCenter(), 50, rl.WHITE)
    DrawTextCentered("PRESS ENTER TO RESET", GetScreenCenter()+{0, 100}, 20, _alpha)
    DrawTextCentered("PRESS ESC TO QUIT", GetScreenCenter()+{0, 200}, 20, rl.RED)
}