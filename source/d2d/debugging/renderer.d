module d2d.debugging.renderer;

import gl3n.linalg;
import derelict.opengl3.gl3;

import d2d.colour;
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
	}

	this() {
		//_shader

		glGenVertexArrays(1, &_vao);
		glGenBuffers(1, &_vbo);
		glGenBuffers(1, &_ibo);

		glBindVertexArray(_vao);
		glBindBuffer(GL_ARRAY_BUFFER, _vbo);
		glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _ibo);



		glBindVertexArray(0);
	}

	~this() {
		deinit();
	}

	/**
	* end
	*/
	public void end() {

	}

	public void draw(IShape shape) {
		shape.draw;
	}


	// TODO: these should be one method that take in an IShape which describes how to draw the object
	/**
	* drawBox
	*/
	public void drawBox(in vec4 rect, in float angle, in Colour colour = Colour.white) {

	}

	/**
	* drawCircle
	*/
	public void drawCircle(in vec2 pos, in float radius, in Colour colour = Colour.white) {

	}

	/**
	* render
	*/
	public void render() {

	}

	/**
	* deinit
	*/
	public void deinit() {

	}

	struct Vertex {
		vec2 position;
		Colour colour;
	}
}
