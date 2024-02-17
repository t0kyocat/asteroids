package main
import rl "vendor:raylib"
import "core:math/rand"

stars : [dynamic]Vec2
starsFar : [dynamic]Vec2

star_rotation : f32

InitStars :: proc(game: ^Game, #any_int quantity: int) -> [dynamic]Vec2 {
    list : [dynamic]Vec2
    for i:= 0; i < quantity; i+=1 {
        pos: Vec2 = {rand.float32_range(0, GetScreenSize().x), rand.float32_range(0, GetScreenSize().y)}
        append(&list, pos)
    }
    return list
}

UpdateStars :: proc(list: ^[dynamic]Vec2, dt: f32) {
    for _, i in list {
        list[i] += Vec2{25, 20} * dt
        if list[i].x > GetScreenSize().x { list[i].x = 0 }
        if list[i].y > GetScreenSize().y { list[i].y = 0 }
        if list[i].x < 0                 { list[i].x = GetScreenSize().x }
        if list[i].y < 0                 { list[i].y = GetScreenSize().y }
    }
    star_rotation += 5
    if star_rotation == 360 do star_rotation = 1
}

DrawStars :: proc(list: ^[dynamic]Vec2, size: f32, alpha: u8) {
    for _, i in list {
        rl.DrawPoly(list[i], 4, size, star_rotation * rl.DEG2RAD, {255,255,255, alpha})
    }
}