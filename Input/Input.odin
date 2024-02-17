package Input

import rl "vendor:raylib"
Keyboard :: rl.KeyboardKey
Vec2 :: [2]f32

//wrappers
IsKeyPressed :: proc{rl.IsKeyPressed}
IsKeyPressedRepeat :: proc{rl.IsKeyPressedRepeat}
IsKeyDown :: proc{rl.IsKeyDown}
IsKeyReleased :: proc{rl.IsKeyReleased}
IsKeyUp :: proc{rl.IsKeyUp}
GetKeyPressed :: proc{rl.GetKeyPressed}
GetCharPressed :: proc{rl.GetCharPressed}
SetExitKey :: proc{rl.SetExitKey}

IsMouseButtonPressed :: proc{rl.IsMouseButtonPressed}
IsMouseButtonDown :: proc{rl.IsMouseButtonDown}
IsMouseButtonReleased :: proc{rl.IsMouseButtonReleased}

GetAxis :: proc(key: Keyboard, key2: Keyboard) -> int {
    x := int(i32(IsKeyDown(key)) - i32(IsKeyDown(key2)))
    return x
}

