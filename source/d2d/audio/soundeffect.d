module d2d.audio.soundeffect;

import std.string : format, fromStringz;

import derelict.sdl2.mixer;

import d2d.errors;

/**
* SoundEffect
*/
class SoundEffect {
	private {
		Mix_Chunk* _chunk;
	}

	public this(Mix_Chunk* chunk) {
		_chunk = chunk;
	}

	/**
	* play
	* Params:
	*	loops = Plays loops times
	*/
	public void play(int loops = 0) {
		if(Mix_PlayChannel(-1, _chunk, loops) == -1) {
			fatalError(format("Mix_PlayChannel error: %s", Mix_GetError().fromStringz));
		}
	}
}
