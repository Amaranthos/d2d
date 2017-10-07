module d2d.lighting.light;

import gl3n.linalg;

import d2d.colour;
import d2d.sprites.batcher;

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
	public void draw(Batcher batch) {
		vec4 dest;
		dest.x = _position.x - _radius;
		dest.y = _position.y - _radius;
		dest.z = 2 * _radius;
		dest.w = 2 * _radius;
		batch.draw(dest, vec4(-1, -1, 2, 2), 0, 0f);
	}

	public vec2 position() const @property { return _position; }
	public float radius() const @property { return _radius; }
	public Colour colour() const @property { return _colour; }

	public void position(vec2 value) @property { _position = value; }
	public void radius(float value) @property { _radius = value; }
	public void colour(Colour value) @property { _colour = value; }
}
