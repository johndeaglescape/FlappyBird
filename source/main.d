import std.stdio;
import raylib;
import std.conv : to;

immutable HEIGHT = 600;
immutable WIDTH = 600;

immutable PILLAR_SPEED = 100;
immutable PILLAR_WIDTH = 40;

float pillarSpawnDateAccumulator = 0;

Pillar[] pillars;

struct Coordinate {
    int x;
    int y;
}

class Sprite
{
	auto position = Coordinate(0, 0);
	auto size = Coordinate(0, 0);

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
		// top
		DrawRectangle(position.x, position.y - size.y + pxVisibleFromTop, size.x, size.y, Colors.WHITE);

		// bottom
		DrawRectangle(position.x, position.y + HEIGHT - pxVisibleFromBottom, size.x, size.y, Colors.WHITE);
	}
}

void tick(float deltaTime)
{
	pillarSpawnDateAccumulator += deltaTime;

	// spawn new pillars
	if (pillarSpawnDateAccumulator >= 1)
	{
		pillarSpawnDateAccumulator -= 1;

		auto pillar = new Pillar();
		pillar.position.x = WIDTH;
	}

	// move pillars
	foreach (pillar; pillars)
	{
		pillar.position.x -= to!int(deltaTime * PILLAR_SPEED);
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
