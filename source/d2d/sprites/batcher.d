module d2d.sprites.batcher;

import derelict.opengl3.gl3;
import gl3n.linalg : vec4, vec2, dot;

import d2d.colour;
import d2d.constants;
import d2d.settings;
import d2d.sprites.batch;
import d2d.sprites.glyph;
import d2d.sprites.sort;
import d2d.vertex;

/**
* Batcher
*/
class Batcher {
	private {
		uint _vbo;
		uint _vao;
		Glyph[] _glyphs;
		Glyph* _data;
		Batch[] _batches;
		Sort _sort;
	}

	this() {}

	public void init() {
		createVertexArray();
	}

	public void begin(Sort sort = Sort.Texture) {
		_sort = sort;
		_batches.length = 0;
		foreach(glyph; _glyphs) { Glyph.deallocate(glyph); }
		_glyphs.length = 0;
	}

	public void end() {
		sort();
		batch();
	}

	public void draw(in vec4 rect, in vec4 uvs, in uint texture, in float depth, in Colour colour = Colour.white) {
		auto glyph = Glyph.allocate();
		glyph.texture = texture;
		glyph.depth = depth;
		glyph.tl = Vertex([rect.x, rect.y + rect.w], colour, [uvs.x, uvs.y + uvs.w]);
		glyph.bl = Vertex([rect.x, rect.y], colour, [uvs.x, uvs.y]);
		glyph.tr = Vertex([rect.x + rect.z, rect.y + rect.w], colour, [uvs.x + uvs.z, uvs.y + uvs.w]);
		glyph.br = Vertex([rect.x + rect.z, rect.y], colour, [uvs.x + uvs.z, uvs.y]);
		_glyphs ~= glyph;
	}

	public void draw(in vec4 rect, in vec4 uvs, in uint texture, in float depth, in float angle, in Colour colour = Colour.white) {
		auto half = vec2(rect.z / 2f, rect.w / 2f);

		auto tl = rotate(vec2(-half.x, half.y), angle);
		auto bl = rotate(vec2(-half.x, -half.y), angle);
		auto br = rotate(vec2(half.x, -half.y), angle);
		auto tr = rotate(vec2(half.x, half.y), angle);

		auto glyph = Glyph.allocate();
		glyph.texture = texture;
		glyph.depth = depth;
		glyph.tl = Vertex([rect.x + tl.x, rect.y + tl.y], colour, [uvs.x, uvs.y + uvs.w]);
		glyph.bl = Vertex([rect.x + bl.x, rect.y + bl.y], colour, [uvs.x, uvs.y]);
		glyph.br = Vertex([rect.x + br.x, rect.y + br.y], colour, [uvs.x + uvs.z, uvs.y]);
		glyph.tr = Vertex([rect.x + tr.x, rect.y + tr.y], colour, [uvs.x + uvs.z, uvs.y + uvs.w]);
		_glyphs ~= glyph;
	}

	public void draw(in vec4 rect, in vec4 uvs, in uint texture, in float depth, in vec2 direction, in Colour colour = Colour.white) {
		import std.math : acos;
		float angle = acos(dot(Constants.right, direction));
		if(direction.y < 0.0f) { angle = -angle; }
		draw(rect, uvs, texture, depth, angle, colour);
	}
	public void render() {
		glBindVertexArray(_vao);
		foreach(batch; _batches) {
			glBindTexture(GL_TEXTURE_2D, batch.texture);
			glDrawArrays(GL_TRIANGLES, batch.offset, batch.count);
		}
		glBindVertexArray(0);
	}

	private void createVertexArray() {
		if(_vao == 0) { glGenVertexArrays(1, &_vao); }
		if(_vbo == 0) { glGenBuffers(1, &_vbo); }

		glBindVertexArray(_vao);
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

		glBindVertexArray(0);
	}

	private void batch() {
		import std.range : empty;
		if(_glyphs.empty) {
			return;
		}

		int offset;
		int vert;

		Vertex[] verts;
		verts.length = _glyphs.length * Constants.countVerts;
		for(int i = 0; i < _glyphs.length; ++i) {
			if(i == 0 || _glyphs[i].texture != _glyphs[i-1].texture) { _batches ~= Batch(offset, Constants.countVerts, _glyphs[i].texture); }
			else { _batches[$-1].count += 6; }

			verts[vert++] = _glyphs[i].tl;
			verts[vert++] = _glyphs[i].bl;
			verts[vert++] = _glyphs[i].br;
			verts[vert++] = _glyphs[i].br;
			verts[vert++] = _glyphs[i].tr;
			verts[vert++] = _glyphs[i].tl;
			offset += 6;
		}

		glBindBuffer(GL_ARRAY_BUFFER, _vbo);
		glBufferData(GL_ARRAY_BUFFER, verts.length * Vertex.sizeof, null, GL_DYNAMIC_DRAW);
		glBufferSubData(GL_ARRAY_BUFFER, 0, verts.length * Vertex.sizeof, verts.ptr);
		glBindBuffer(GL_ARRAY_BUFFER, 0);
	}

	private void sort() {
		import std.algorithm : sort;
		final switch(_sort) with(Sort) {
			case None:
				break;

			case Front:
				_glyphs.sort!((a, b) => a.depth < b.depth);
				break;

			case Back:
				_glyphs.sort!((a, b) => a.depth > b.depth);
				break;

			case Texture:
				_glyphs.sort!((a, b) => a.texture < b.texture);
				break;
		}
	}

	private vec2 rotate(vec2 point, float angle) {
		import std.math : sin, cos;
		return(vec2(point.x * cos(angle) - point.y * sin(angle), point.x * sin(angle) + point.y * cos(angle)));
	}
}
