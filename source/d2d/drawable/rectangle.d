module d2d.drawable.rectangle;

import gl3n.linalg;

import d2d;
import d2d.colour;
import d2d.drawable.ishape;
import d2d.drawable.vertex;

/**
* Rectangle
*/
class Rectangle : IShape {
	public {
		float top, left, width, height;
		float angle;
		Colour colour;
	}

	this() {}

	/**
	* draw
	*/
	public void draw(ref Vertex[] verts, ref uint[] indices) {
		int index = cast(int)verts.length;

		auto half = vec2(width / 2f, height / 2f);
		auto tl = rotate(vec2(-half.x, half.y), angle, true);
		auto bl = rotate(vec2(-half.x, -half.y), angle, true);
		auto br = rotate(vec2(half.x, -half.y), angle, true);
		auto tr = rotate(vec2(half.x, half.y), angle, true);

		verts ~= Vertex(vec2(left + tl.x, top + tl.y), colour);
		verts ~= Vertex(vec2(left + bl.x, top + bl.y), colour);
		verts ~= Vertex(vec2(left + br.x, top + br.y), colour);
		verts ~= Vertex(vec2(left + tr.x, top + tr.y), colour);

		indices ~= index;
		indices ~= index + 1;

		indices ~= index + 1;
		indices ~= index + 2;

		indices ~= index + 2;
		indices ~= index + 3;

		indices ~= index + 3;
		indices ~= index;
	}
}
