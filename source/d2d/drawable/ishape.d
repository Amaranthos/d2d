module d2d.drawable.ishape;

import d2d.drawable.vertex;

/**
* IShape
*/
interface IShape {
	public void draw(ref Vertex[] verts, ref ulong[] indices);
}
