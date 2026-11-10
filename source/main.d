import std.stdio;
import raylib;
import std.conv : to;

immutable HEIGHT = 600;
immutable WIDTH = 600;

immutable PILLAR_SPEED = 100;
immutable PILLAR_WIDTH = 40;

float pillarSpawnDateAccumulator = 0;

Pillar[] pillars;

class Sprite
{
	auto position = Vector2(0, 0);
	auto size = Vector2(0, 0);

	void draw()
	{
	}

}

class Pillar : Sprite
{
	int pxVisibleFromTop = 50;
	int pxVisibleFromBottom = 50;

	this()
	{
		size.x = PILLAR_WIDTH;
		size.y = HEIGHT * 2; // more then the screen so we can easily move it on y

		pillars ~= this;
	}

	override void draw()
	{
		int px = to!int(position.x);
		int py = to!int(position.y);
		int sx = to!int(size.x);
		int sy = to!int(size.y);

		// top
		DrawRectangle(px, py - sy + pxVisibleFromTop, sx, sy, Colors.WHITE);

		// bottom
		DrawRectangle(px, py + HEIGHT - pxVisibleFromBottom, sx, sy, Colors.WHITE);
	}
}

void tick(float deltaTime)
{
	pillarSpawnDateAccumulator += deltaTime;

	// move pillars
	foreach (pillar; pillars)
	{
		pillar.position.x -= deltaTime * PILLAR_SPEED;
	}

	// spawn new pillars
	if (pillarSpawnDateAccumulator >= 1)
	{
		pillarSpawnDateAccumulator -= 1;

		auto pillar = new Pillar();
		pillar.position.x = WIDTH - pillarSpawnDateAccumulator * PILLAR_SPEED;
	}
}

void render()
{
	ClearBackground(Colors.SKYBLUE);

	foreach (pillar; pillars)
	{
		pillar.draw();
	}
}

int main()
{
	InitWindow(WIDTH, HEIGHT, "Flappybird");
	scope (exit)
		CloseWindow();

	SetTargetFPS(60);

	while (!WindowShouldClose())
	{
		tick(GetFrameTime());

		BeginDrawing();

		render();

		EndDrawing();
	}

	return 0;
}
