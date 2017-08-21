module d2d.particles.particle;

import gl3n.linalg;

import d2d.colour;

/**
* Particle
*/
struct Particle {
	vec2 position = vec2(0);
	vec2 velocity = vec2(0);
	float size = 1.0f;
	float lifetime = -1.0f;
	Colour colour = Colour.white;;
}
