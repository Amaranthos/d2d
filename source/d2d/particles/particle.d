module d2d.particles.particle;

import gl3n.linalg;

import d2d.colour;

/**
* Particle
*/
struct Particle {
	private {
		vec2 _position = vec2(0);
		vec2 _velocity = vec2(0);
		float _size = 1.0f;
		float _lifetime = 0.0f;
		Colour _colour = Colour.white;;
	}

	//public this(in vec2 position, in vec2 velocity, in float size = 1.0f, in float lifetime = 1.0f, in Colour colour = Colour.white) {
	//	_position = position;
	//	_lifetime = lifetime;
	//	_size = size;
	//	_lifetime = lifetime;
	//	_colour = colour;
	//}

	public float lifetime() const @property { return _lifetime; }
	public vec2 position() const @property { return _position; }
	public vec2 velocity() const @property { return _velocity; }
	public float size() const @property { return _size; }
	public Colour colour() const @property { return _colour; }

	public void lifetime(float value) @property { _lifetime = value; }
	public void position(vec2 value) @property { _position = value; }
}
