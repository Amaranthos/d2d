module d2d.colour;

import derelict.sdl2.sdl : SDL_Color;

struct Colour {
	ubyte r;
	ubyte g;
	ubyte b;
	ubyte a = 255;

	static Colour white() @property {
		return Colour(255, 255, 255, 255);
	}

	static Colour red() @property {
		return Colour(255, 0, 0, 255);
	}

	static Colour green() @property {
		return Colour(0, 255, 0, 255);
	}

	static Colour blue() @property {
		return Colour(0, 0, 255, 255);
	}

	static Colour black() @property {
		return Colour(0, 0, 0, 255);
	}

	static Colour purple() @property {
		return Colour(80, 0, 80, 255);
	}

	SDL_Color opCast(T : SDL_Color)() const {
		return SDL_Color(r, g, b, a );
	}
}
