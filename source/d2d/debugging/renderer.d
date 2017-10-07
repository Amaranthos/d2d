module d2d.debugging.renderer;

import gl3n.linalg;
import derelict.opengl3.gl3;

import d2d.camera;
import d2d.colour;
import d2d.constants;
import d2d.drawable;
import d2d.shader;

/**
* Renderer
*/
class Renderer {
	private {
		Shader _shader;
		Vertex[] _vertices;
		uint[] _indices;
		uint _vbo, _vao, _ibo;
		uint _count;
	}

	this() {
		_shader = new Shader;
		_shader.compile(vertSrc, fragSrc);

		glGenVertexArrays(1, &_vao);
		glGenBuffers(1, &_vbo);
		glGenBuffers(1, &_ibo);

		glBindVertexArray(_vao);
		glBindBuffer(GL_ARRAY_BUFFER, _vbo);
		glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _ibo);

		// Position
		glEnableVertexAttribArray(Constants.shaderPositionLoc);
		glVertexAttribPointer(Constants.shaderPositionLoc, 2, GL_FLOAT, GL_FALSE, Vertex.sizeof, cast(void*)Vertex.position.offsetof);

		// Colour
		glEnableVertexAttribArray(Constants.shaderColourLoc);
		glVertexAttribPointer(Constants.shaderColourLoc, 4, GL_UNSIGNED_BYTE, GL_TRUE, Vertex.sizeof, cast(void*)Vertex.colour.offsetof);

		glBindVertexArray(0);
	}

	~this() {
		deinit();
	}

	/**
	* end
	*/
	public void end() {
		// Vertices
		glBindBuffer(GL_ARRAY_BUFFER, _vbo);
		glBufferData(GL_ARRAY_BUFFER, _vertices.length * Vertex.sizeof, null, GL_DYNAMIC_DRAW);
		glBufferSubData(GL_ARRAY_BUFFER, 0, _vertices.length * Vertex.sizeof, _vertices.ptr);
		glBindBuffer(GL_ARRAY_BUFFER, 0);

		//Indices
		glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _ibo);
		glBufferData(GL_ELEMENT_ARRAY_BUFFER, _indices.length * uint.sizeof, null, GL_DYNAMIC_DRAW);
		glBufferSubData(GL_ELEMENT_ARRAY_BUFFER, 0, _indices.length * uint.sizeof, _indices.ptr);
		glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);

		_count = cast(int)_indices.length;
		_indices.length = 0;
		_vertices.length = 0;
	}

	public void draw(IShape shape) {
		shape.draw(_vertices, _indices);
	}

	/**
	* render
	*/
	public void render(Camera cam, float lineWidth = 1f) {
		_shader.use;

		auto mvpLoc = _shader.getUniform("mvp");
		glUniformMatrix4fv(mvpLoc, 1, GL_TRUE, cam.mvp.value_ptr);

		glLineWidth(lineWidth);
		glBindVertexArray(_vao);
		glDrawElements(GL_LINES, _count, GL_UNSIGNED_INT, null);
		glBindVertexArray(0);

		_shader.unuse;
	}

	/**
	* deinit
	*/
	public void deinit() {
		if(_vao) { glDeleteVertexArrays(1, &_vao); }
		if(_vbo) { glDeleteVertexArrays(1, &_vbo); }
		if(_ibo) { glDeleteVertexArrays(1, &_ibo); }

		delete _shader;
	}
}

private enum vertSrc =
`#version 410

layout(location = 0) in vec2 position;
layout(location = 1) in vec4 colour;

out vec4 fragColour;

uniform mat4 mvp;

void main() {
	gl_Position = mvp * vec4(position, 0, 1);
	fragColour = colour;
}
`;

private enum fragSrc =
`#version 410

in vec4 fragColour;

out vec4 colour;

void main() {
	colour = fragColour;
}
`;
