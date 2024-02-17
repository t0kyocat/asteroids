package main

import rl "vendor:raylib"
import "core:math/linalg"
import "core:math/rand"
import "Input"

MAX_ASTEROIDS : int : 64

ASTEROID_DELAY : f32 : 1.3
ASTEROID_LIFE : f32 : 7

SCREEN_PADDING : f32 : 128

_sizes : []AsteroidSize : { .SMALL, .MEDIUM, . LARGE }

AsteroidArray :: [dynamic]Asteroid
_lastAsteroidCreationTime : f32 = 0

SpawnAsteroid :: proc(list: ^AsteroidArray, pos: Vec2 , size: AsteroidSize, split: bool) -> ^Asteroid {

    ast_velocity := split ? Vec2Rotate({0, 1}, rand.float32_range(0, 359)) : (GetScreenCenter() - pos)

    ast_velocity = 
    split ? (linalg.normalize0(ast_velocity) * rand.float32_range(ASTEROID_SPD_MIN/3.0, ASTEROID_SPD_MAX/3.0)) : 
    linalg.normalize0(ast_velocity) * rand.float32_range(ASTEROID_SPD_MIN, ASTEROID_SPD_MAX)
    
    //DEBUG------
    line0[0] = pos
    line1[0] = pos
    line0[1] = pos + Vec2Rotate(ast_velocity * 10, -ASTEROID_RANDOM_ANGLE)
    line1[1] = pos + Vec2Rotate(ast_velocity * 10, ASTEROID_RANDOM_ANGLE)
    //-----------
    ast_velocity = Vec2Rotate(ast_velocity, rand.float32_range(-ASTEROID_RANDOM_ANGLE, ASTEROID_RANDOM_ANGLE))

    ast := CreateAsteroid(pos, ast_velocity, size)
    if len(list) < MAX_ASTEROIDS {
        
        append(list, ast)
    }
    return &ast
}

DrawAsteroids :: proc(list: ^AsteroidArray) {
    for _, i in list {
        DrawAsteroid(&list[i])
    }
}

UpdateAsteroids :: proc(list: ^AsteroidArray, dt: f32) {
    AutoSpawnAsteroids(list)

    for _, i in list {
        UpdateAsteroid(&list[i], dt)
        if f32(rl.GetTime()) > (list[i].creationTime + ASTEROID_LIFE) {
            unordered_remove(list, i)
        }
    }
}

ExplodeAsteroid :: proc(game: ^Game, list: ^AsteroidArray, #any_int index: int) {
    i := &list[index]
    switch i.size {
        case .LARGE:
            SpawnAsteroid(list, i.position+10, .MEDIUM, true)
            SpawnAsteroid(list, i.position-10, .MEDIUM, true)
            game.player.score += 10
            unordered_remove(list, index)
            break
        case .MEDIUM:
            SpawnAsteroid(list, i.position+10, .SMALL, true)
            SpawnAsteroid(list, i.position-10, .SMALL, true)
            game.player.score += 20
            unordered_remove(list, index)
            break
        case .SMALL:
            game.player.score += 30
            unordered_remove(list, index)
            break
    }
}

GetAsteroidNextPos :: proc() -> Vec2 {

    result : Vec2 = {-SCREEN_PADDING, -SCREEN_PADDING}

    if bool(rl.GetRandomValue(0, 1)) {
        if bool(rl.GetRandomValue(0, 1)) {
            result.y = GetScreenSize().y + SCREEN_PADDING
        }
            result.x = rand.float32_range(-SCREEN_PADDING, GetScreenSize().x + SCREEN_PADDING)
    }
    else {
        if bool(rl.GetRandomValue(0, 1)) {
            result.x = GetScreenSize().x + SCREEN_PADDING
        }
            result.y = rand.float32_range(-SCREEN_PADDING, GetScreenSize().y + SCREEN_PADDING)
    }
    return result
}

AutoSpawnAsteroids :: proc(list: ^AsteroidArray) {
    if f32(rl.GetTime()) > _lastAsteroidCreationTime + ASTEROID_DELAY {
        SpawnAsteroid(list, GetAsteroidNextPos(), rand.choice(_sizes), false)
        _lastAsteroidCreationTime = f32(rl.GetTime())
    }
}