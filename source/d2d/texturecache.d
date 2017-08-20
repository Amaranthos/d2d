module d2d.texturecache;

import std.string : format;

import d2d.errors;
import d2d.texture;

/**
* TextureCache
*/
class TextureCache {
	private {
		Texture[string] _textures;
	}

	public this() {}

	public Texture get(in string path) {
		if(path !in _textures) {
			Texture texture = new Texture;
			texture.load(path);
			if(texture is null) {
				fatalError(format("Could not load %s", path));
			}
			_textures[path] = texture;
		}

		return _textures[path];
	}
}
