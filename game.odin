package main

import rl "vendor:raylib"

import "core:math"
import "core:math/rand"
import "core:math/linalg"

import "Input"

InitGame :: #force_inline proc(using game: ^Game) {


    InitWindow(&state, 1080, 720, "GAME")
    rl.SetConfigFlags({.MSAA_4X_HINT, .VSYNC_HINT})
    SetMaxFPS(60)
    cam.zoom = 1.0
    player = Player{
        score = 0,
        state = .DEFAULT,
        color = PLAYER_COL,
        projectileColor = rl.RED,
        hp = 5,
        position = GetScreenCenter(),
        velocity = {0.0,0.0},
        acceleration = 0.0,
        rotation = 180.0,
        size = 20.0,
        collideCircle = 15.0,
        lastFireTime = -1.0,
        game = game,
    }
    
    rand.set_global_seed(rand._system_random())
    stars = InitStars(game, 145)
    starsFar = InitStars(game, 80)

}

GameUpdate :: #force_inline proc(using game: ^Game,  dt: f32) {

    UpdateScreenSize(game)

    #partial switch state.screen {
        case .GAME:
            UpdatePlayer(&player, dt)
            UpdateAsteroids(&asteroids, dt)
            UpdateProjectiles(&projectiles, dt)
            CheckCollisionProjectiles(game, &asteroids, &projectiles)
            UpdateCamera(&cam)
            UpdateStars(&stars, dt)
            UpdateStars(&starsFar, dt)
            break
        case .MENU:
            UpdateTitle()
            UpdateAsteroids(&asteroids, dt)
            UpdateStars(&stars, dt)
            UpdateStars(&starsFar, dt)
            if Input.IsKeyDown(Keyboard.ENTER) {
                GameReset(game)  
                game.state.screen = .GAME
            }
            break
        case .DEAD:
            UpdateCamera(&game.cam)
            UpdateStars(&stars, dt)
            UpdateStars(&starsFar, dt)
            UpdateTitle()
            if Input.IsKeyPressed(Keyboard.ENTER) { GameReset(game) }
            if Input.IsKeyPressed(Keyboard.ESCAPE) { rl.CloseWindow() }
            break
    }
    

    
}

GameDraw :: #force_inline proc(using game: ^Game) {
    #partial switch state.screen{
        case .GAME:
            BeginDrawing()
    
            rl.ClearBackground(rl.ALMOST_BLACK)
            
            BeginMode2D(cam)
        
                DrawPlayer(&player)
                DrawProjectiles(&projectiles)
                DrawAsteroids(&game.asteroids)
                DrawStars(&stars, 2, 200)
                DrawStars(&starsFar, 1, 130)
                DrawScore(game)
                ShowDebug(game)
        
            EndMode2D()
        
            EndDrawing()
            break
        case .MENU:
            BeginDrawing()
    
            rl.ClearBackground(rl.ALMOST_BLACK)
            
            BeginMode2D(cam)
            DrawStars(&stars, 2, 240)
            DrawStars(&starsFar, 1, 160)
            DrawAsteroids(&game.asteroids)
            DrawTitle()
            DrawEnterToPlay()
            EndMode2D()     
            EndDrawing()
            break
        case .DEAD:
            BeginDrawing()
                rl.ClearBackground(rl.ALMOST_BLACK)
            BeginMode2D(cam)            
            DrawStars(&stars, 2, 240)
            DrawStars(&starsFar, 1, 160)
            DrawDeadScreen(game)
            EndMode2D()
            EndDrawing()
            break
    }
}


GameIsRunning :: #force_inline proc (exitkey: Keyboard) -> bool {
    Input.SetExitKey(Keyboard.KEY_NULL)
    if Input.IsKeyPressed(exitkey) || bool(rl.WindowShouldClose()) {
        return false
    }
    else {
        return true
    }

}


GameReset :: proc(game: ^Game) {
    game.state.screen = .GAME
    clear_dynamic_array(&game.asteroids)
    clear_dynamic_array(&game.projectiles)
    ResetPlayer(&game.player)
}

DrawScore :: proc(game: ^Game) {
    rl.DrawText(rl.TextFormat("SCORE: %d", game.player.score), 10,10, 20, rl.BLUE)
}