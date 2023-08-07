import 'dart:async';

import 'package:flame/components.dart';
import 'package:survival_arena/survival_arena.dart';

class BackgroundTile extends SpriteComponent with HasGameRef<SurvivalArena> {
  BackgroundTile({position, this.backgroundColor = 'Gray'})
      : super(position: position);
  final String backgroundColor;
  final double scrollSpeed = 0.4;
  @override
  FutureOr<void> onLoad() {
    priority = -1;
    size = Vector2.all(64.6);
    sprite = Sprite(game.images.fromCache('Background/$backgroundColor.png'));
    return super.onLoad();
  }

  @override
  void update(double dt) {
    position.y += scrollSpeed;
    double tileSize = 64;
    int scrollHeight = (game.size.y / tileSize).floor();
    if (position.y > scrollHeight * tileSize) position.y = -tileSize;
    super.update(dt);
  }
}
