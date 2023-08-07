import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:survival_arena/components/arena/background_tile.dart';
import 'package:survival_arena/components/utils/collision_block.dart';
import 'package:survival_arena/components/fruit/fruit.dart';
import 'package:survival_arena/components/player/player.dart';
import 'package:survival_arena/survival_arena.dart';

class Arena extends World with HasGameRef<SurvivalArena> {
  final String arenaLevel;
  late TiledComponent arena;
  final Player player;

  List<CollisionBlock> listCollisionBlock = [];

  Arena({required this.arenaLevel, required this.player});

  @override
  FutureOr<void> onLoad() async {
    arena = await TiledComponent.load("$arenaLevel.tmx", Vector2.all(16));
    add(arena);

    _scrollingBackground();
    _spawnObjects();
    _addCollisions();

    return super.onLoad();
  }

  void _scrollingBackground() {
    final backgroundLayer = arena.tileMap.getLayer('Background');

    const tileSize = 64;
    final numTilesY = (game.size.x / tileSize).floor();
    final numTilesX = (game.size.y / tileSize).floor();
    for (double y = 0, x = 0;
        y < (game.size.y / numTilesY) && x < numTilesX;
        y++, x++) {
      if (backgroundLayer != null) {
        final backgroundColor =
            backgroundLayer.properties.getValue('BackgroundColor');
        for (double y = 0; y < game.size.y / numTilesY; y++) {
          for (double x = 0; x < numTilesX; x++) {
            final backgroundTile = BackgroundTile(
              backgroundColor: backgroundColor ?? 'Gray',
              position: Vector2(x * tileSize, y * tileSize - tileSize),
            );

            add(backgroundTile);
          }
        }
      }
    }
  }

  void _spawnObjects() {
    final spawnPointsLayer = arena.tileMap.getLayer<ObjectGroup>('Spawnpoints');
    for (final spawnPoint in spawnPointsLayer!.objects) {
      switch (spawnPoint.class_) {
        case 'Player':
          player.position = Vector2(spawnPoint.x, spawnPoint.y);
          add(player);
          break;
        case 'Fruit':
          final fruit = Fruit(
            name: spawnPoint.name,
            position: Vector2(spawnPoint.x, spawnPoint.y),
            size: Vector2(spawnPoint.width, spawnPoint.height),
          );
          add(fruit);
        default:
      }
    }
  }

  void _addCollisions() {
    final collisionsLayer = arena.tileMap.getLayer<ObjectGroup>('Collisions');
    if (collisionsLayer != null) {
      for (final collision in collisionsLayer.objects) {
        switch (collision.class_) {
          case 'Platform':
            final platform = CollisionBlock(
                position: Vector2(collision.x, collision.y),
                size: Vector2(collision.width, collision.height),
                isPlatform: true);
            listCollisionBlock.add(platform);
            add(platform);
            break;
          default:
            final block = CollisionBlock(
              position: Vector2(collision.x, collision.y),
              size: Vector2(collision.width, collision.height),
            );
            listCollisionBlock.add(block);
            add(block);
        }
      }
    }
    player.collisionBlocks = listCollisionBlock;
  }
}
