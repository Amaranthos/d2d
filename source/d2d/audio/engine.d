module d2d.audio.engine;

import std.string : format, fromStringz;

import derelict.sdl2.mixer;

import d2d.audio.music;
import d2d.audio.soundeffect;
import d2d.configuration;
import d2d.errors;

/**
* AudioEngine
* TODO: Should be manager?? Move resoucre loading to cache
*/
static class AudioEngine {
	static private {
		Mix_Chunk*[string] _effects;
		Mix_Music*[string] _music;

		bool isInit = false;
	}

	static public void init() {
		if(isInit) { return; } // TODO: Log

		if(Mix_Init(MIX_INIT_MP3 | MIX_INIT_OGG) == -1) {
			fatalError(format("Mix_Init error: %s", Mix_GetError().fromStringz));
		}

		if(Mix_OpenAudio(MIX_DEFAULT_FREQUENCY, MIX_DEFAULT_FORMAT, 2, 2048) == -1) {
			fatalError(format("Mix_Init error: %s", Mix_GetError().fromStringz));
		}

		Mix_AllocateChannels(Config.audio.channels);
		if(Config.audio.mute) {
			foreach(i; 0..Config.audio.channels) {
				Mix_Volume(i, 0);
			}
		}

		isInit = true;
	}

	static public void deinit() {
		if(isInit) {
			foreach(ref it; _effects) {
				Mix_FreeChunk(it);
			}
			_effects.clear;

			foreach(ref it; _music) {
				Mix_FreeMusic(it);
			}
			_music.clear;

			Mix_Quit();
		}
	}

	static public T get(T)(in string path) {
		return null;
	}

	static public T get(T : SoundEffect)(in string path) {
		if(!isInit) { return null; }

		if(path !in _effects) {
			Mix_Chunk* chunk = Mix_LoadWAV(path.ptr);
			if(chunk is null) {
				fatalError(format("Could not load %s, error %s", path, Mix_GetError().fromStringz));
			}
			_effects[path] = chunk;
		}

		return new SoundEffect(_effects[path]);
	}

	static public T get(T : Music)(in string path) {
		if(!isInit) { return null; }

		if(path !in _music) {
			Mix_Music* music = Mix_LoadMUS(path.ptr);
			if(music is null) {
				fatalError(format("Could not load %s, error %s", path, Mix_GetError().fromStringz));
			}
			_music[path] = music;
		}

		return new Music(_music[path]);
	}
}
