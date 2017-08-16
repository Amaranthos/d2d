module d2d.texturecache;

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
		if(path in _textures) {
			return _textures[path];
		}
		else {
			Texture texture = new Texture;
			texture.load(path);
			_textures[path] = texture;
			return texture;
		}
	}
}
