module d2d.drawable.circle;

import gl3n.linalg;

import d2d;
import d2d.colour;
import d2d.drawable.ishape;
import d2d.drawable.vertex;

/**
* Circle
*/
class Circle : IShape {
	public {
		float x, y;
		float radius;
		Colour colour;
	}

	this() {}

	/**
	* draw
	*/
	public void draw(ref Vertex[] verts, ref uint[] indices) {
		import std.math : cos, sin, PI;

		enum numVerts = 100;
		int index = verts.length;
		foreach(i; 0..numVerts) {
			float angle = (i / cast(float)numVerts * 2 * PI);
			verts ~= Vertex(vec2(x + cos(angle) * radius, y + sin(angle) * radius), colour);
		}

		foreach(i; 0..numVerts - 1) {
			indices ~= index + i;
			indices ~= index + i + 1;
		}

		indices ~= index + numVerts - 1;
		indices ~= index;
	}
}
