package main

import rl "vendor:raylib"
import "core:math/linalg"
import "core:math/rand"
import "Input"

ASTEROID_SPD_MIN : f32 : 180
ASTEROID_SPD_MAX : f32 : 400

ASTEROID_RANDOM_ANGLE : f32 : 10 * f32(rl.DEG2RAD)

ASTEROID_ROT_SPD_MIN : f32 : 60
ASTEROID_ROT_SPD_MAX : f32 : 340


Asteroid :: struct {
    position: Vec2,
    velocity: Vec2,
    size: AsteroidSize,
    rotation: f32,
    rotationSpd: f32,
    creationTime: f32,
}

AsteroidSize :: enum {
    SMALL = 1,
    MEDIUM = 2,
    LARGE = 4,
}


CreateAsteroid :: proc(pos, vel: Vec2, size: AsteroidSize) -> Asteroid {
    return Asteroid{
        position = pos,
        velocity = vel,
        size = size,
        rotation = rand.float32_range(0, 360),
        rotationSpd = rand.float32_range(ASTEROID_ROT_SPD_MIN, ASTEROID_ROT_SPD_MAX),
        creationTime = f32(rl.GetTime()),
    }
}

UpdateAsteroid :: proc(using ast: ^Asteroid, dt: f32) {
    position += velocity * dt
    rotation += rotationSpd * dt
}

DrawAsteroid :: proc(using ast: ^Asteroid) {
    rl.DrawPolyLines(position, 5, 16 * f32(size), rotation, /*WHITE*/{240,240,240,240})
}

AsteroidRadius :: proc(ast: ^Asteroid) -> f32 {
    return 16.0 * f32(ast.size)
}