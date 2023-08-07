import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:survival_arena/components/utils/custom_hitbox.dart';
import 'package:survival_arena/survival_arena.dart';

class Fruit extends SpriteAnimationComponent
    with HasGameRef<SurvivalArena>, CollisionCallbacks {
  final String name;
  late TiledComponent arena;
  Fruit({position, size, this.name = 'Bananas'})
      : super(position: position, size: size);

  final double stepTime = 0.05;
  final hitbox = CustomHitBox(offsetX: 10, offsetY: 10, width: 12, height: 12);
  bool _collected = false;
  @override
  FutureOr<void> onLoad() {
    priority = -1;
    add(RectangleHitbox(
        position: Vector2(hitbox.offsetX, hitbox.offsetY),
        size: Vector2(hitbox.width, hitbox.height),
        collisionType: CollisionType.passive));
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Items/Fruits/$name.png'),
      SpriteAnimationData.sequenced(
        amount: 17, // i frame dell'animazione dell'immagine
        stepTime: stepTime,
        textureSize: Vector2.all(32),
      ),
    );

    return super.onLoad();
  }

  void collidingWithPlayer() {
    if (!_collected) {
      animation = SpriteAnimation.fromFrameData(
        game.images.fromCache('Items/Fruits/Collected.png'),
        SpriteAnimationData.sequenced(
            amount: 6, // i frame dell'animazione dell'immagine
            stepTime: stepTime,
            textureSize: Vector2.all(32),
            loop: false),
      );
      _collected = true;
      //
    }
    Future.delayed(const Duration(milliseconds: 400), () => removeFromParent());
  }
}
