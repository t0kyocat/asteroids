package main

import rl "vendor:raylib"
import "core:math/linalg"
import "core:math"
import "core:fmt"
import "Input"
import "GameControls"

PI : f32 : 3.14159265359

PLAYER_ROT_SPD : f32 : 200
PLAYER_COL : Color = rl.WHITE
PLAYER_ACCEL : f32 : 40
PLAYER_DECEL : f32 : 0.978
PLAYER_MAX_SPEED : f32 : 35
PLAYER_NUDGE_FORCE : f32 : 30
PLAYER_FIRE_DELAY : f32 : 0.33
PLAYER_STUN_SECONDS : f32 : 1

hit: bool

PlayerState :: enum {
    DEFAULT = 0,
    STUNNED,
    DEAD,
}

Player :: struct {
    score: i32,
    state: PlayerState,
    hp: i32,
    color: Color,
    projectileColor: Color,
    position: Vec2,
    velocity: Vec2,
    acceleration: f32,
    rotation: f32,
    size: f32,
    collideCircle: f32,
    lastFireTime: f32,
    lastColTime: f32,
    game: ^Game
}


UpdatePlayer :: proc(using player: ^Player, dt: f32) {
    #partial switch player.state {
        case .DEFAULT:
            player.color = PLAYER_COL
            PlayerMove(player, dt)
            ShootProjectiles(player, &game.projectiles)
            hit, lastColTime = BouncePlayerFromAsteroids(player, &player.game.asteroids)

                //change state and decrease health when hit
                if hit {
                    DecreaseHealth(player, 1)
                    ChangePlayerState(player, .STUNNED)
                    ActiveCameraShake(&game.cam, 1.5, 0.82)
                    hit = false
                }

            WrapPlayer(player)
            break
        case .STUNNED:
            PlayerMove(player, dt / 1.2)
            WrapPlayer(player)
            PlayerBlink(player)
            if GetTime() > lastColTime + PLAYER_STUN_SECONDS {
                ChangePlayerState(player, .DEFAULT)
            }
            break
    }
    if player.hp <= 0 do player.game.state.screen = .DEAD

}




PlayerMove :: proc(using player: ^Player, dt: f32) {
    yInput := Input.IsKeyDown(GameControls.Move_up)

    length := linalg.length(velocity)
    facing_dir := GetPlayerFacingDir(player)

    //accelerate
    if yInput != false {
        velocity += (facing_dir * PLAYER_ACCEL) * dt*2
    }
    //decelerate
    if yInput == true {
        velocity *= PLAYER_DECEL
    }
    //limit velocity
    if length > PLAYER_MAX_SPEED {
        velocity = linalg.normalize0(velocity) * PLAYER_MAX_SPEED
    }     
    position += velocity * dt *10
    PlayerUpdateAngle(player, dt)
}

PlayerUpdateAngle :: proc(using player: ^Player, dt: f32) {
    xInput := f32(Input.GetAxis(GameControls.Rotate_right, GameControls.Rotate_left))
    rotation += (xInput * PLAYER_ROT_SPD * dt)

}

WrapPlayer :: proc(using player: ^Player) {
    if position.y < 0 - size {
        position.y = f32(rl.GetScreenHeight())
    }
    if position.y > f32(rl.GetScreenHeight())+size {
        position.y = 0
    }

    if position.x < 0 - size {
        position.x = f32(rl.GetScreenWidth())
    }
    if position.x > f32(rl.GetScreenWidth())+size {
        position.x = 0
    }

}

DrawPlayer :: proc(using player: ^Player) {
    rl.DrawPoly(position, 3, size, rotation+90, color)
    DrawLineAngle(position, rotation, 15, 20, color, false)
    //debug-------------
    if _showCollisionShapes {
        DrawPlayerCollisionCircle(player)
    }
    DrawPlayerHP(player)
    //debug-------------
}

ShootProjectiles :: proc(player: ^Player, proj_list: ^ProjectileArray) {
    if Input.IsKeyDown(GameControls.shoot) {
        if GetTime() > player.lastFireTime + PLAYER_FIRE_DELAY {
            SpawnProjectile(proj_list, player.position, player.rotation, PROJECTILE_LENGTH, PROJECTILE_THICKNESS, player.projectileColor)
            player.lastFireTime = f32(rl.GetTime())
        }
    }
}

CheckCollisionPlayer :: proc(player: ^Player,ast: ^AsteroidArray) -> (bool, ^Asteroid) {
    for _, i in ast {
        if rl.CheckCollisionCircles(player.position, player.collideCircle, ast[i].position, AsteroidRadius(&ast[i])) {
            asteroid := &ast[i]
            return true, asteroid
        }
    }
    return false, nil
}

DecreaseHealth :: proc(player: ^Player, #any_int amount: i32) {
    player.hp -= amount
}

BouncePlayerFromAsteroids :: proc(player: ^Player, list: ^AsteroidArray) -> (bool, f32) {
    col, ast := CheckCollisionPlayer(player, list)
    if col {
        RepelPlayer(player, ast.position, PLAYER_NUDGE_FORCE)
        col_time := GetTime()
        return true, col_time
    }
    return false, 0
}

ChangePlayerState :: proc(player: ^Player, newState: PlayerState) -> PlayerState {
    player.state = newState
    return newState
}

RepelPlayer :: proc(player: ^Player, repelPoint: Vec2, force: f32) {
    nudge := linalg.normalize0(player.position - repelPoint)

    player.velocity = nudge * force
}


GetPlayerFacingDir :: proc(player: ^Player) -> Vec2 {
    facing_dir := Vec2Rotate({0, 1}, linalg.to_radians(player.rotation))
    return facing_dir
}

DrawPlayerHP :: proc(player: ^Player) {
    rl.DrawText(rl.TextFormat("%d", player.hp), i32(player.position.x), i32(player.position.y - 35), 20, rl.BLUE)
}

DrawPlayerState :: proc(player: ^Player) {
    state : cstring
    #partial switch player.state {
        case .DEFAULT:
            state = "DEFAULT"
        case .STUNNED:
            state = "STUNNED"
    }
    rl.DrawText(rl.TextFormat("State: %s", state), i32(player.position.x), i32(player.position.y - 60), 16, rl.WHITE)
}

CheckPlayerDead :: proc(player: ^Player) -> bool {
    if player.hp <= 0 {
        return true
    }
    return false
}

PlayerBlink :: proc(player: ^Player) {
    if int(GetTime() / 0.1) % 2 == 0.0 {
                
        player.color = rl.BLANK
    }
    else {player.color = PLAYER_COL}

}

ResetPlayer :: proc(using player: ^Player) {
    score = 0
    state = .DEFAULT
    player.color = PLAYER_COL
    hp = 5;
    position = GetScreenCenter()
    velocity = {0.0,0.0}
    acceleration = 0.0
    rotation = 180.0
    size = 20.0
    collideCircle = 15.0
    lastFireTime = -1.0
    game = game
}