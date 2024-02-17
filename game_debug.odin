package main

import "Input"
import rl "vendor:raylib"

_showCollisionShapes : bool : false
_showAngleCone : bool : false
_showCounts : bool : false
_drawPlayerColCircle : bool : false

line0 : [2]Vec2
line1 : [2]Vec2



DrawCenterGrid :: proc() {
	center: Vec2i
	center.x = i32(GetScreenCenter().x)
	center.y = i32(GetScreenCenter().y)
	rl.DrawLine(center.x, center.y - 3000, center.x, center.y + 3000, rl.WHITE)
	rl.DrawLine(center.x - 3000, center.y, center.x + 3000, center.y, rl.WHITE)
}

DrawPlayerCollisionCircle :: proc(using player: ^Player) {
    if _drawPlayerColCircle {
        rl.DrawCircleLinesV(position,collideCircle,rl.MAGENTA)
    }
}

DrawAsteroidAngleCone :: proc() {
    if _showAngleCone{
    rl.DrawLineV(line0[0], line0[1], rl.RED)
    rl.DrawLineV(line1[0], line1[1], rl.BLUE)
    }
    else{return}
}

ShowCurrentAsteroids :: proc(game: ^Game) {
    if _showCounts{
    rl.DrawText(rl.TextFormat("Asteroids %d", len(game.asteroids)), 10, 10, 15, rl.WHITE)
    rl.DrawText(rl.TextFormat("projectiles %d", len(game.projectiles)), 10, 30, 15, rl.WHITE)
}
}

ShowDebug :: proc(game: ^Game) {
    ShowCurrentAsteroids(game)
    DrawAsteroidAngleCone()
    DrawPlayerCollisionCircle(&game.player)
}