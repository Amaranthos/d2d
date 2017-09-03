module d2d.spatial.grid;

import gl3n.linalg : vec2;

import d2d.spatial.cell;

/**
* Grid
*/
class Grid(T) {
	private {
		Cell!T[] _cells;
		int _width;
		int _height;
		int _cellSize;
		int _cols;
		int _rows;
	}

	this(int width, int height, int cellSize) {
		import std.math : ceil;
		_width = width;
		_height = height;
		_cellSize = cellSize;
		_cols = cast(int)ceil(width / cast(float)cellSize);
		_rows = cast(int)ceil(height / cast(float)cellSize);

		_cells = new Cell!T[_rows * _cols];
	}

	public void add(T item, int i, int j)
	in {
		import std.string : format;
		assert(item !is null);
		assert(i >= 0 && i <= _cols, format("Index: %s, cols: %s", i, _cols));
		assert(j >= 0 && j <= _rows, format("Index: %s, cols: %s", i, _cols));
	}
	body {
		//this[i, j].contents ~= item;
		//_cells[i + _cols * j];
	}

	import std.stdio; // TODO: remove
	public void add(T item, in vec2 pos) {
		add(item, cast(int)(pos.x / _cellSize), cast(int)(pos.y / _cellSize));
		//writeln(_cells);1
	}

	ref Cell!T opIndex(int i, int j)
	in {
		import std.string : format;
		assert(i >= 0 && i <= _cols, format("Index: %s, cols: %s", i, _cols));
		assert(j >= 0 && j <= _rows, format("Index: %s, rows: %s", j, _rows));
	}
	body {
		//writefln("Index: %s, %s", i + _cols * j, this);
		return _cells[i + _cols * j];
	}

	override string toString() {
		import std.string : format;
		return format("Grid: rows: %s, cols: %s \n[\n%(%s\n%)\n]", _rows, _cols, _cells);
	}
}
