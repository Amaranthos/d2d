module d2d.debugging.profiler.handlers.fileoutputhandler;

import std.stdio : writeln, writefln, File;
import std.file;
import std.path;

import d2d.debugging.profiler.profiler;
import d2d.debugging.profiler.iprofileroutputhandler;

/**
* FileOutputHandler
*/
class FileOutputHandler : IProfilerOutputHandler {
	private {
		File file;
	}

	this(in string path) {
		if(!path.dirName.exists) { mkdir(path.dirName); }
		file.open(path, "w");
	}

	~this() {
		file.flush;
		file.close;
	}

	void begin() {
		file.writeln(" Min(%) : Avg(%) : Max(%) :  # : Name");
		file.writeln("---------------------------------------");
	}

	void output(in float min, in float avg, in float max, in int callCount, in string name, in int numParents) {
		import std.string : rightJustify;
		file.writefln(" %6.2f : %6.2f : %6.2f : %2d : %s", min, avg, max, callCount, rightJustify(name, numParents + name.length, ' '));
	}

	void end() {
		file.writeln();
	}
}
