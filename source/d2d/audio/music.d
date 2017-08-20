module d2d.audio.music;

import std.string : format;

import derelict.sdl2.mixer;

import d2d.errors;


/**
* Music
*/
class Music {
	private {
		Mix_Music* _music;
	}

	this(Mix_Music* music) {
		_music = music;
	}

	/**
	* play
	* Params:
	*	loops = Loops forever if -1 else plays loops times
	*/
	public void play(int loops = 1) {
		if(Mix_PlayMusic(_music, loops) == -1) {
			fatalError(format("Mix_Init error: %s", Mix_GetError()));
		}
	}

	/**
	* pause
	*/
	static public void pause() {
		Mix_PauseMusic();
	}

	/**
	* resume
	*/
	static public void resume() {
		Mix_ResumeMusic();
	}

	/**
	* stop
	*/
	static public void stop() {
		Mix_HaltMusic();
	}
}
