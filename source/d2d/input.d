module d2d.input;

import std.stdio;

import derelict.sdl2.sdl;
import gl3n.linalg : vec2;

/**
* Input
*/
static class Input {
	static private {
		bool[uint] _keys;
		bool[uint] _prevKeys;
		vec2 _mouseCoords = vec2(0f);
	}

	static this() {}

	static public void update() {
		_prevKeys = _keys.dup;
	}

	static public void events(in SDL_Event event) {
		switch(event.type) {
			case SDL_KEYDOWN:
				press(event.key.keysym.sym);
				break;

			case SDL_KEYUP:
				release(event.key.keysym.sym);
				break;

			case SDL_MOUSEBUTTONDOWN:
				press(event.button.button);
				break;

			case SDL_MOUSEBUTTONUP:
				release(event.button.button);
				break;

			case SDL_MOUSEMOTION:
				_mouseCoords = vec2(event.motion.x, event.motion.y);
				break;

			default: break;
		}
	}

	static public bool get(uint key) {
		return (key in _keys) ? _keys[key] : false;
	}

	static public bool up(uint key) {
		return ((key in _prevKeys) ? _prevKeys[key] : false) ? !get(key) : false;
	}

	static public bool down(uint key) {
		return ((key in _prevKeys) ? _prevKeys[key] : false) ? false : get(key);
	}


	static private void press(uint key) {
		_keys[key] = true;
	}

	static private void release(uint key) {
		_keys[key] = false;
	}

	static public vec2 mouseCoords() @property { return _mouseCoords; }
}
