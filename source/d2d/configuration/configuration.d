module d2d.configuration.configuration;

import d2d.templates.singleton;

public static Configuration Config;

static this() {
	import jsonx;
	import std.stdio;
	import std.file : exists, readText;

	string source;
	if("config.json".exists) { source = "config.json".readText; }
	if(source[$-1] == '\n') { source = source[0..$-1]; }
	Config = jsonDecode!Configuration(source);
}

/**
* Configuration
*/
private class Configuration {
	Audio audio;
	Debugging debugging;
	Particles particles;
	Render render;
	Window window;
}

/**
* Window
*/
private struct Window {
	string title;
	int width;
	int height;
}

/**
* Render
*/
private struct Render {
	float maxFps;
	bool vsync;
}

/**
* Debugging
*/
private struct Debugging {
	bool printFps;
	bool profiling; // TODO: make enum, with selector for output
	bool rendering;
	bool escapeExits;
}

/**
* Audio
*/
private struct Audio {
	int channels;
	bool mute;
}

/**
* Particles
*/
private struct Particles {
	int max;
}

/**
* Misc
*/
private struct Misc {

}
