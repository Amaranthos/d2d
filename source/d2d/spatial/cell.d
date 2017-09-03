module d2d.spatial.cell;

/**
* Cell
*/
struct Cell(T) {
	T[] contents;

	string toString() {
		import std.string : format;
		return format("\t[\n%(\t\t%s\n%)\n\t]", contents);
	}
}
