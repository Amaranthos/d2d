module d2d.animation.tilesheet;

import gl3n.linalg;

import d2d.texture;
import d2d.resourcemanager;

/**
* TileSheet
*/
class TileSheet {
	private {
		Texture _texture;
		int _tileWidth, _tileHeight;
	}

	this() {}

	/**
	* init
	*/
	public void init(in string texturePath, in int tileWidth, in int tileHeight) {
		_texture =  ResourceManager.textureCache.get(texturePath);
		_tileWidth = tileWidth;
		_tileHeight = tileHeight;
	}

	/**
	* uvs
	*/
	public vec4 uvs(int index) {
		int x = index % _tileWidth;
		int y = index / _tileWidth;

		return vec4(x / cast(float)_tileWidth, y / cast(float)_tileHeight, 1.0f / _tileWidth, 1.0f / _tileHeight);
	}
}
