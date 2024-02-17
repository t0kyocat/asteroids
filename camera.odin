package main

import rl "vendor:raylib"
import "core:math/rand"
import "Input"

GameCam :: rl.Camera2D
CameraShakeValue : f32 = 0
CameraShakeDecrease : f32 = 0.8

ShakeCamera :: proc(cam: ^GameCam, magnitude: f32) {
    cam.offset = {rand.float32_range(0,magnitude), rand.float32_range(0, magnitude)} * CameraShakeValue
    cam.rotation = rand.float32_range(-1.5, 1.5) * CameraShakeValue
}

ActiveCameraShake :: proc(cam: ^GameCam, value: f32, decrease: f32) {
    CameraShakeValue = value
    CameraShakeDecrease = decrease
}

UpdateCamera :: proc(cam: ^GameCam) {
    ShakeCamera(cam, 5)
    CameraShakeValue *= CameraShakeDecrease
}