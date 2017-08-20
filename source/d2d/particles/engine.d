module d2d.particles.engine;

import d2d.particles.system;
import d2d.sprites.batcher;
/**
* ParticleEngine
*/
static class ParticleEngine {
	static private {
		System[] _systems;
	}

	static public void add(System system) {
		_systems ~= system;
	}

	static public void update() {
		foreach(s; _systems) {
			s.update;
		}
	}

	static public void draw(Batcher batcher) {
		foreach(s; _systems) {
			batcher.begin;
			s.draw(batcher);
			batcher.end;
			batcher.render;
		}
	}

	static public void deinit() {
		foreach(s; _systems) {
			delete s;
		}
		delete _systems;
	}
}
