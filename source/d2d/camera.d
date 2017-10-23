module d2d.camera;

import gl3n.linalg : mat4, vec3, vec2, vec4;

/**
* Camera
* TODO: Camera culling
*/
class Camera {
	private {
		bool _dirty = true;
		vec2 _position = vec2(0f);
		mat4 _mvp = mat4(1f);
		float _zoom = 1.0f / 1.25f; //1f;
		int _width;
		int _height;
	}

	static Camera _inst;

	public this() {
		if(_inst is null) {
			_inst = this;
		}
	}

	public void init(in int width, in int height) {
		_width = width;
		_height = height;
	}

	public void update() {
		if(_dirty) {
			_mvp = mat4.orthographic(-0.5f * _width + _position.x, 0.5f * _width + _position.x, 0.5f * _height + _position.y, -0.5f * _height + _position.y, -1f, 1f).scale(_zoom, _zoom, 0f);
			_dirty = false;
		}
	}

	public vec2 screenToWorld(in vec2 screen) {
		return (screen - vec2(0.5f * _width, 0.5f * _height)) + _position;
	}

	public bool isInView(in vec4 rect) {
		auto halfScaledW = 0.5f * _width / _zoom;
		auto halfScaledH = 0.5f * _height / _zoom;

		return( rect.x < _position.x + halfScaledW
			&& rect.x + rect.z > _position.x - halfScaledW
			&& rect.y < _position.y + halfScaledH
			&& rect.y + rect.w  > _position.y - halfScaledH
		);
	}

	public void position(in vec2 position) @property { _position = position; _dirty = true; }
	public vec2 position() const @property { return _position; }

	public void zoom(in float zoom) @property { import gl3n.math : clamp;  _zoom = clamp(zoom, 0f, float.max); _dirty = true; }
	public float zoom() const @property { return _zoom; }

	public mat4 mvp() const @property { return _mvp; }
	public int width() const @property { return _width; }
	public int height() const @property { return _height; }

	static public Camera main() @property { return _inst; }
}
