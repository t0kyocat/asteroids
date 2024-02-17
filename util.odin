package main

import rl "vendor:raylib"
import "core:math"
import "core:math/rand"
import "core:math/linalg"

Keyboard :: rl.KeyboardKey
Color :: rl.Color
Rect :: rl.Rectangle

DrawRect :: proc{rl.DrawRectangle,rl.DrawRectangleV}
GetTime :: #force_inline proc() -> f32 {
    return f32(rl.GetTime())
}
SetMaxFPS :: proc{rl.SetTargetFPS}
GetDeltaTime :: proc{rl.GetFrameTime}
BeginDrawing :: proc{rl.BeginDrawing}
EndDrawing :: proc{rl.EndDrawing}
BeginMode2D :: proc{rl.BeginMode2D}
EndMode2D :: proc{rl.EndMode2D}
CloseGame :: proc{rl.CloseWindow}
Vec2Rotate :: proc{rl.Vector2Rotate}

DrawLineAngle :: proc(pos: Vec2, angle: f32, length: f32, thickness: f32,color: Color, positionisMiddle: bool) {
    rect := rl.Rectangle{pos.x,pos.y,thickness,length}
    originY := positionisMiddle ? length / 2 : length
    origin: Vec2 = {thickness / 2, originY}
    rl.DrawRectanglePro(rect, origin, angle, color)
}


DrawTextCentered :: proc(title: cstring, pos: Vec2, size: i32, color: Color) {
    rl.DrawText(title, i32(pos.x) - (rl.MeasureText(title, size)/2), i32(pos.y), size, color )
}