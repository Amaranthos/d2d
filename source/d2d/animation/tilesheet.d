module d2d.animation.tilesheet;

import gl3n.linalg;

import d2d.texture;

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
	public void init(in Texture texture, in int tileWidth, in int tileHeight) {
		_texture = texture;
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
