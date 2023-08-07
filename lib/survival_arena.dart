import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/painting.dart';
import 'package:survival_arena/components/player/player.dart';
import 'package:survival_arena/components/arena/arena.dart';

class SurvivalArena extends FlameGame
    with HasKeyboardHandlerComponents, DragCallbacks, HasCollisionDetection {
  late final CameraComponent cam;
  late JoystickComponent joystickComponent;
  Player player = Player(character: 'Mask Dude');
  bool showJostyck = false;

  @override
  Color backgroundColor() {
    return const Color(0xFF211F30);
  }

  @override
  FutureOr<void> onLoad() async {
    await images.loadAllImages();

    final world = Arena(player: player, arenaLevel: "Arena-01");

    cam = CameraComponent.withFixedResolution(
        world: world, width: 640, height: 360);
    cam.viewfinder.anchor = Anchor.topLeft;

    addAll([cam, world]);
    if (showJostyck) {
      addJoystick();
    }

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (showJostyck) {
      updateJoystick();
    }
    super.update(dt);
  }

  void addJoystick() {
    joystickComponent = JoystickComponent(
        knob: SpriteComponent(
          sprite: Sprite(
            images.fromCache('HUD/joystick.png'),
          ),
        ),
        background: SpriteComponent(
          sprite: Sprite(
            images.fromCache('HUD/knob.png'),
          ),
        ),
        margin: const EdgeInsets.only(left: 32.0, bottom: 32.0));
    add(joystickComponent);
  }

  void updateJoystick() {
    switch (joystickComponent.direction) {
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
      case JoystickDirection.left:
        //player.playerDirection = PlayerDirection.left;
        player.horizontalMovement = -1;
        break;
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
      case JoystickDirection.right:
        //player.playerDirection = PlayerDirection.right;
        player.horizontalMovement = 1;
        break;
      default:
        player.horizontalMovement = 0;
        //idle
        break;
    }
  }
}
