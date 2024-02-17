package main

import rl "vendor:raylib"
import "core:math/linalg"
import "core:math"
import "core:fmt"
import "Input"

PROJECTILE_OFFSET : f32 : 25

SpawnProjectile :: proc(list: ^ProjectileArray, pos: Vec2, rot, length, thick: f32, color: Color) {
    facing_dir := rl.Vector2Rotate({0, 1}, linalg.to_radians(rot));
    proj := CreateProjectile(pos + facing_dir * PROJECTILE_OFFSET , rot+90, length, thick, color)
    append(list, proj)
}

UpdateProjectiles :: proc(list: ^ProjectileArray, dt: f32) {
    for _, i in list {
        UpdateProjectile(&list[i], dt)

        if f32(rl.GetTime()) > (list[i].creationTime + PROJECTILE_LIFE) {
            unordered_remove(list, i)
        }
    }
    
}

DrawProjectiles :: proc(list: ^ProjectileArray) {
    for _, i in list {
        DrawProjectile(&list[i])
    }
}

CheckCollisionProjectile :: proc(ast: ^Asteroid, proj: ^Projectile) -> bool {
     if rl.CheckCollisionPointCircle(proj.position, ast.position, AsteroidRadius(ast)) {
        return true
     }
     else {
        return false
     }
}

CheckCollisionProjectiles :: proc(game: ^Game, asteroids: ^AsteroidArray, projectiles: ^ProjectileArray) {
    #no_bounds_check {
    for _, i in asteroids {
        for _, j in projectiles {
            if CheckCollisionProjectile( &asteroids[i] ,&projectiles[j]) {
                ActiveCameraShake(&game.cam, 0.3, 0.82)
                ExplodeAsteroid(game, asteroids, i)
                ordered_remove(projectiles, j)
            }
        }
    }
}
}