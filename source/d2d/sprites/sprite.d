module d2d.sprites.sprite;

import derelict.opengl3.gl3;

import d2d.colour;
import d2d.constants;
import d2d.resourcemanager;
import d2d.settings;
import d2d.texture;
import d2d.vertex;

/**
* Sprite
*/
class Sprite {
	private {
		float _x, _y, _w, _h;
		uint _vbo;
		Texture _texture;
	}

	public this() {}

	public ~this() {
		if(_vbo) { glDeleteBuffers(1, &_vbo); }
	}

	public void init(in float x, in float y, in float width, in float height, in string texturePath) {
		_x = x;
		_y = y;
		_w = width;
		_h = height;

		_texture = ResourceManager.textureCache.get(texturePath);

		if(!_vbo) { glGenBuffers(1, &_vbo); }

		Vertex[6] verts = [
			// Tri 1
			  { [x + width, y + height], Colour.white, [1f, 1f] }
			, { [x, y + height], Colour.white, [0f, 1f] }
			, { [x, y], Colour.white, [0f, 0f] }
			// Tri 2
			, { [x, y], Colour.white, [0f, 0f] }
			, { [x + width, y], Colour.white, [1f, 0f] }
			, { [x + width, y + height], Colour.white, [1f, 1f] }
		];

		glBindBuffer(GL_ARRAY_BUFFER, _vbo);
		glBufferData(GL_ARRAY_BUFFER, verts.length * Vertex.sizeof, verts.ptr, GL_STATIC_DRAW);
		glBindBuffer(GL_ARRAY_BUFFER, 0);
	}

	public void draw() {
		glBindTexture(GL_TEXTURE_2D, _texture.id);
		glBindBuffer(GL_ARRAY_BUFFER, _vbo);

		// Position
		glEnableVertexAttribArray(Constants.shaderPositionLoc);
		glVertexAttribPointer(Constants.shaderPositionLoc, 2, GL_FLOAT, GL_FALSE, Vertex.sizeof, cast(void*)Vertex.position.offsetof);

		// Colour
		glEnableVertexAttribArray(Constants.shaderColourLoc);
		glVertexAttribPointer(Constants.shaderColourLoc, 4, GL_UNSIGNED_BYTE, GL_TRUE, Vertex.sizeof, cast(void*)Vertex.colour.offsetof);

		// Colour
		glEnableVertexAttribArray(Constants.shaderUVLoc);
		glVertexAttribPointer(Constants.shaderUVLoc, 2, GL_FLOAT, GL_TRUE, Vertex.sizeof, cast(void*)Vertex.uv.offsetof);

		glDrawArrays(GL_TRIANGLES, 0, 6);
		glDisableVertexAttribArray(Constants.shaderPositionLoc);
		glDisableVertexAttribArray(Constants.shaderColourLoc);
		glDisableVertexAttribArray(Constants.shaderUVLoc);
		glBindBuffer(GL_ARRAY_BUFFER, 0);
	}
}
