module d2d.timing.delta;

import derelict.sdl2.sdl;

import d2d.configuration;
import d2d.constants;

/**
* DeltaTime
*/
class DeltaTime {
	private {
		static float _prev;
		static float _current;
		static float _time;
	}

	private static this() {
		_prev = 0.0f;
		_current = 0.0f;
	}

	public static void init() {
		_prev = SDL_GetTicks();
	}

	public static void update() {
		_current = SDL_GetTicks();
		_time = (_current - _prev) / (Constants.milliseconds / Config.render.maxFps);
		_prev = _current;

	}

	public static float time() @property { return 1 / _time; }
}
