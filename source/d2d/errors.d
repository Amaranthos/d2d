module d2d.errors;

import std.stdio : writeln, readln, stdout;
import core.stdc.stdlib : exit;

import derelict.sdl2.sdl : SDL_Quit;

public static void fatalError(in string error) {
	writeln(error ~ "\nExiting...");
	stdout.flush();
	SDL_Quit();
	exit(1);
}
