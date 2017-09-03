module d2d;

import derelict.opengl3.gl3;
import derelict.sdl2.sdl;
import derelict.sdl2.ttf;
import derelict.sdl2.mixer;

public {
	import d2d.audio;
	import d2d.camera;
	import d2d.colour;
	import d2d.constants;
	import d2d.debugging;
	import d2d.errors;
	import d2d.input;
	import d2d.kernal;
	import d2d.particles;
	import d2d.resourcemanager;
	import d2d.settings;
	import d2d.shader;
	import d2d.spatial;
	import d2d.sprites;
	import d2d.templates;
	import d2d.texture;
	import d2d.timing;
	import d2d.texturecache;
	import d2d.ui;
	import d2d.vertex;
	import d2d.views;
	import d2d.window;
}

enum AppState {
	  Running
	, Exit
}

public void init() {
	DerelictGL3.load;
	DerelictSDL2.load;
	//DerelictSDL2Image.load;
	DerelictSDL2Mixer.load;
	DerelictSDL2ttf.load;
	//DerelictSDL2Net.load;

	SDL_Init(SDL_INIT_EVERYTHING);
	TTF_Init();
	SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, 1);
	SDL_GL_SetAttribute(SDL_GL_ACCELERATED_VISUAL, 1);
}

public void quit() {
	TTF_Quit();
	SDL_Quit();
}

import gl3n.linalg : vec2;

public vec2 rotate(in vec2 vector, in float angle) {
	import std.math : sin, cos, PI;
	auto x = cos(angle * (PI / 180));
	auto y = sin(angle * (PI / 180));

	return vec2(
		  vector.x * x - vector.y * y
		, vector.x * y + vector.y * x
	).normalized;
}
