module d2d.lighting.light;

import gl3n.linalg;

import d2d.colour;

/**
* Light
*/
class Light {
	private {
		Colour _colour;
		vec2 _position;
		float _radius;
	}

	this() {}

	/**
	* draw
	*/
	public void draw(in SpriteBatch batch) {
		vec4 dest;
		dest.x = _position.x - _radius;
		dest.y = _position.y - _radius;
		dest.z = 2 * _radius;
		dest.w = 2 * _radius;
		batch.draw(dest, vec4(-1, -1, 2, 2), 0, 0f, _colour, 0f);
	}
}
