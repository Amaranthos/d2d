module d2d.particles.system;

import gl3n.linalg;

import d2d.colour;
import d2d.constants;
import d2d.particles.particle;
import d2d.settings;
import d2d.texture;
import d2d.timing.delta;
import d2d.sprites.batcher;

alias ParticleUpdate = void delegate(ref Particle);

/**
* System
*/
class System {
	private {
		float _decayRate = 0.1f;
		Particle[] _particles;
		int _maxParticles;
		float _size;
		Texture _texutre;
		int _index;
		ParticleUpdate _update;
	}

	public this(int maxParticles, float decayRate, Texture texutre, ParticleUpdate update = null) {
		_decayRate = decayRate;
		_texutre = texutre;
		_maxParticles = maxParticles;
		_particles = new Particle[maxParticles];

		_update = update is null ? &defaultUpdate : update;

		foreach(p; _particles) {
			_particles[findFreeIndex()] = Particle();
		}
	}

	public ~this() {
		delete _particles;
	}

	public void add(in vec2 position, in vec2 velocity, in float size = 1.0f, in float lifetime = 1.0f, in Colour colour = Colour.white) {
		_particles[findFreeIndex()] = Particle(position, velocity, size, lifetime, colour);
	}

	public void update() {
		foreach(ref p; _particles) {
			if(p.lifetime >= 0.0f) {
				_update(p);
				p.lifetime -= _decayRate * DeltaTime.time;
			}
		}
	}

	public void draw(Batcher batcher) {
		foreach(p; _particles) {
			if(p.lifetime >= 0.0f) {
				batcher.draw(vec4(p.position - vec2(p.size), vec2(p.size)), Constants.uvs, _texutre.id, 0.0f, p.colour);
			}
		}
	}

	private int findFreeIndex() {
		foreach(i; _index.._maxParticles) {
			if(_particles[i].lifetime < 0f) {
				_index = i;
				return i;
			}
		}

		foreach(i; 0.._index) {
			if(_particles[i].lifetime < 0f) {
				_index = i;
				return i;
			}
		}

		return 0;
	}

	private void defaultUpdate(ref Particle p) {
		p.position += p.velocity * DeltaTime.time;
	}
}
