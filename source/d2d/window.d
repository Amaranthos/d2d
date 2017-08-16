module d2d.window;

import derelict.sdl2.sdl;
import derelict.opengl3.gl3;

import d2d.errors;
import d2d.settings;

/**
* Window
*/
class Window {
	private {
		SDL_Window* _window;
		int _width, _height;
	}

	this() {}

	public void create(in string name, in int width, in int height, in int flags = 0, )
	out {
		assert(_window !is null);
	}
	body {
		_width = width;
		_height = height;

		int sdlFlags = SDL_WINDOW_OPENGL;
		if(flags & Flags.Fullscreen) { sdlFlags |= SDL_WINDOW_FULLSCREEN_DESKTOP; }
		if(flags & Flags.Borderless) { sdlFlags |= SDL_WINDOW_BORDERLESS; }
		if(flags & Flags.Resizable) { sdlFlags |= SDL_WINDOW_RESIZABLE; }

		_window = SDL_CreateWindow(name.ptr, SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, _width, _height, sdlFlags);
		if(_window is null) {
			fatalError("SDL Window was not created");
		}

		SDL_GLContext context = SDL_GL_CreateContext(_window);
		if(context is null) {
			fatalError("SDL_GL context could not be created");
		}

		DerelictGL3.reload;

		glClearColor(Settings.clearColour.r, Settings.clearColour.g, Settings.clearColour.b, Settings.clearColour.a);
		SDL_GL_SetSwapInterval(Settings.vsync);

		glEnable(GL_BLEND);
		glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	}

	public void swapBuffer() {
		SDL_GL_SwapWindow(_window);
	}

	public int width() const @property { return _width; }
	public int height() const @property { return _height; }

	enum Flags {
		  Fullscreen = 0x1
		, Borderless = 0x2
		, Resizable = 0x3
	}
}
