module d2d.views.view;

import derelict.sdl2.sdl : SDL_Event;
import derelict.opengl3.gl3 : glClearColor;

import d2d.colour;
import d2d.kernal;
import d2d.views.viewstate;

/**
* View
* TODO: Draw should operate on a list of GOs?
*/
abstract class View {
	private {
		ViewState _state = ViewState.None;
		Kernal* _kernal = null;
		int _index = -1;
		Colour _backgroundColour = Colour.black;
	}

	/**
	* build
	*/
	abstract public void build(Kernal* kernal, int index) {
		_kernal = kernal;
		_index = index;
	}

	/**
	* destroy
	*/
	abstract public void destroy();

	/**
	* onEntry
	*/
	abstract public void onEntry() {
		_state = ViewState.Running;
	}

	/**
	* onExit
	*/
	abstract public void onExit();

	/**
	* update
	*/
	abstract public void update();

	/**
	* events
	*/
	abstract public void events(SDL_Event event);

	/**
	* draw
	*/
	abstract public void draw() {
		glClearColor(_backgroundColour.r, _backgroundColour.g, _backgroundColour.b, _backgroundColour.a);
	}

	/**
	* next
	*/
	abstract public int next() const;

	/**
	* previous
	*/
	abstract public int previous() const;

	override string toString() const {
		import std.string : format;
		return format("View: state: %s, index: %s", _state, _index);
	}

	public int index() const @property { return _index; }
	public ViewState state() const @property { return _state; }
	public void state(ViewState value) @property { _state = value; }

	public Colour backgroundColour() const @property { return _backgroundColour; }
	public void backgroundColour(Colour value) @property { _backgroundColour = value; }
}
