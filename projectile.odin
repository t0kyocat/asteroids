package main

import rl "vendor:raylib"
import "core:math/linalg"
import "core:math"
import "Input"

PROJECTILE_SPEED : f32 : 780
PROJECTILE_LIFE : f32 : 3
PROJECTILE_LENGTH : f32 : 30
PROJECTILE_THICKNESS : f32 : 5

ProjectileArray :: [dynamic]Projectile

Projectile :: struct {
    position: Vec2,
    length: f32,
    color: Color,
    thick: f32,
    rotation: f32,
    creationTime: f32,
}

CreateProjectile :: proc(pos: Vec2, rot: f32, length, thick: f32, color: Color) -> Projectile{
    return Projectile{
        position = pos,
        color = color,
        rotation = rot,
        length = length,
        thick = thick,
        creationTime = f32(rl.GetTime()),
    }
    
}

UpdateProjectile :: proc(using proj: ^Projectile, dt: f32) {
    position += {math.cos(rotation * rl.DEG2RAD), math.sin(rotation * rl.DEG2RAD)} * PROJECTILE_SPEED * dt


}

DrawProjectile :: proc(using proj: ^Projectile) {
    DrawLineAngle(position, rotation+90, PROJECTILE_LENGTH, PROJECTILE_THICKNESS, color, true)
}