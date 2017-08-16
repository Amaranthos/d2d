module d2d.timing.fps;

import derelict.sdl2.sdl;

import d2d.constants;
import d2d.settings;

/**
* FPSLimiter
*/
class FPSLimiter {
	private {
		float _fps = 0f;
		float _start = 0f;
		float _prevTicks = 0f;
		float[] _dTBuffer = new float[Constants.framerateSamples];
		int _frame;
	}

	this() {}

	public void begin() {
		_start = SDL_GetTicks();
	}

	public void end() {
		calc();
		float ticks = SDL_GetTicks() - _start;
		if(1000f / Settings.maxFPS > ticks) {
			SDL_Delay(cast(uint)(1000f / Settings.maxFPS - ticks));
		}
	}

	public void print() {
		if(!Settings.printFPS) { return; }

		if(_frame % Constants.framerateSamples == 0) {
			// TODO: Logger
			import std.stdio : writefln, stdout;
			writefln("FPS: %s", _fps);
			stdout.flush();
		}
	}

	private void calc() {
		import std.algorithm : sum;

		auto ticks = SDL_GetTicks();
		_dTBuffer[_frame % Constants.framerateSamples] = ticks - _prevTicks;
		_prevTicks = ticks;

		_frame++;
		auto count = _frame < Constants.framerateSamples ? _frame : Constants.framerateSamples;
		float avg = _dTBuffer[0..count].sum() / count;
		_fps = avg > 0 ? 1000f / avg : 60;
	}

	public float fps() const @property { return _fps; }
}
