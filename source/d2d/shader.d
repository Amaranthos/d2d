module d2d.shader;

import derelict.opengl3.gl3;

import d2d.errors;

/**
* Shader
*/
class Shader {
	private {
		uint _program;
	}

	public this() {}

	public ~this() {
		glDeleteProgram(_program);
	}

	public void compile(in string vertPath, in string fragPath) {
		void checkProgam(in uint program) {
			import std.string : format;

			int result, len;
			glGetProgramiv(program, GL_LINK_STATUS, &result);
			if(!result) {
				glGetProgramiv(program, GL_INFO_LOG_LENGTH, &len);
				char[] infoLog = new char[len];
				glGetShaderInfoLog(program, 512, null, infoLog.ptr);
				fatalError(format("Shader program compliation failed: %s", infoLog));
			}
		}

		auto vertShader = glCreateShader(GL_VERTEX_SHADER);
		compileShader(vertPath, vertShader);

		auto fragShader = glCreateShader(GL_FRAGMENT_SHADER);
		compileShader(fragPath, fragShader);

		_program = glCreateProgram();
		glAttachShader(_program, vertShader);
		glAttachShader(_program, fragShader);
		glLinkProgram(_program);
		checkProgam(_program);

		glDeleteShader(vertShader);
		glDeleteShader(fragShader);
	}

	private void compileShader(in string path, in uint shader) {
		import std.string : toStringz;

		void checkShader(in uint shader) {
			import std.string : format;

			int result, len;
			glGetShaderiv(shader, GL_COMPILE_STATUS, &result);
			if(!result) {
				glGetShaderiv(shader, GL_INFO_LOG_LENGTH, &len);
				char[] infoLog = new char[len];
				glGetShaderInfoLog(shader, 512, null, infoLog.ptr);
				fatalError(format("Shader compliation failed: %s", infoLog));
			}
		}

		auto src = loadSource(path).toStringz;
		glShaderSource(shader, 1, &src, null);
		glCompileShader(shader);
		checkShader(shader);
	}

	private string loadSource(in string path) {
		import std.file : exists, readText;

		string source;
		if(path.exists) { source = path.readText; }
		else { fatalError("Error reading file: " ~ path ~ " does not exist"); }
		return source;
	}

	public void use() const {
		glUseProgram(_program);
	}

	public void unuse() const {
		glUseProgram(0);
	}

	public int getUniform(in string name) {
		import std.string : toStringz;
		auto loc = glGetUniformLocation(_program, name.toStringz);
		if(loc == GL_INVALID_INDEX) { fatalError("Uniform " ~ name ~ " not found"); }
		return loc;
	}

	public uint program() const @property { return _program; }
}
