package main

import rl "vendor:raylib"
import "core:math"
import "core:math/rand"
import "core:math/linalg"

Vec2 :: [2]f32
Vec2i :: [2]i32
Vec3 :: [3]f32
Vec3i :: [3]i32



Game :: struct{
    state: State,
    cam: GameCam,
    player: Player,
    asteroids: AsteroidArray,
    projectiles: ProjectileArray,
}

Window :: struct {
	width:  i32,
	height: i32,
	title:  cstring,
}

State :: struct {
	window: Window,
    screen: Screen,
}

Screen :: enum {
    GAME,
    MENU,
    DEAD,
    ABOUT,
}

UpdateScreenSize :: proc(using game: ^Game) {
    state.window.height = rl.GetScreenHeight();
    state.window.width = rl.GetScreenWidth()
}


InitWindow :: #force_inline proc(state: ^State, w , h: i32, title: cstring = "GAME") {
	state.window = Window{w, h, title}
	rl.InitWindow(state.window.width, state.window.height, state.window.title)
}

GetScreenCenter :: proc() -> Vec2 {
	center: Vec2
	center.x = f32(rl.GetScreenWidth() / 2.0)
	center.y = f32(rl.GetScreenHeight() / 2.0)

	return center
}
GetScreenSize :: proc() -> Vec2 {
    screen: Vec2
	screen.x = f32(rl.GetScreenWidth())
	screen.y = f32(rl.GetScreenHeight())

	return screen
}



