module d2d.views.list;

import std.stdio;

import d2d.kernal;
import d2d.views.view;

/**
* List
*/
class List {
	private {
		Kernal* _kernal = null;
		View[] _views;
		int _current = -1;
	}

	this(Kernal kernal) {
		_kernal = &kernal;
	}

	~this() {
		foreach(v; _views) {
			v.destroy;
		}
		_views.length = 0;
		_current = -1;
	}

	/**
	* next
	*/
	public View next() {
		if(current.next != -1) { _current = current.next; }
		return current;
	}

	/**
	* previous
	*/
	public View previous() {
		if(current.previous != -1) { _current = current.previous; }
		return current;
	}

	/**
	* add
	*/
	public void add(View view) {
		view.build(_kernal, cast(int)_views.length);
		_views ~= view;
	}

	/**
	* current
	*/
	public View current() {
		return _current == -1 ? null : _views[_current];
	}

	/**
	* current
	*/
	public void current(int index) {
		_current = index;
	}
}
