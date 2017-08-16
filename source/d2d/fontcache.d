module d2d.fontcache;

import derelict.sdl2.ttf;

import d2d.errors;

/**
* FontCache
*/
class FontCache {
	private {
		TTF_Font*[string] _fonts;
	}

	public this() {}

	public TTF_Font* get(in string path, in int size) {
		import std.string : format;
		string key = format("%s_%s", path, size);

		if(key !in _fonts) {
			auto font = TTF_OpenFont(path.ptr, size);
			if(font is null) {
				fatalError(format("Could not load %s, error: %s", path, TTF_GetError()));
			}
			_fonts[key] = font;
		}

		return _fonts[key];
	}
}
