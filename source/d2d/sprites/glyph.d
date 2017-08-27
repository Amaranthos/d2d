module d2d.sprites.glyph;

import gl3n.linalg : vec2;

import d2d.vertex;

class Glyph {
	static private Glyph _freelist;
	private Glyph _next;

	static public Glyph allocate() {
		Glyph g;
		if(_freelist) {
			g = _freelist;
			_freelist = g._next;
		}
		else {
			g = new Glyph();
		}
		return g;
	}

	static public void deallocate(Glyph g) {
		g._next = _freelist;
		_freelist = g;
	}

	uint texture;
	float depth;
	Vertex tl;
	Vertex bl;
	Vertex tr;
	Vertex br;
}
