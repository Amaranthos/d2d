module d2d.debugging.profiler.handlers.stdoutoutputhandler;

import std.stdio : writeln, writefln;

import d2d.debugging.profiler.profiler;
import d2d.debugging.profiler.iprofileroutputhandler;

/**
* StdoutOutputHandler
*/
class StdoutOutputHandler : IProfilerOutputHandler {
	void begin() {
		writeln(" Min(%) : Avg(%) : Max(%) :  # : Name");
		writeln("---------------------------------------");
	}

	void output(in float min, in float avg, in float max, in int callCount, in string name, in int numParents) {
		import std.string : rightJustify;
		writefln(" %6.2f : %6.2f : %6.2f : %2d : %s", min, avg, max, callCount, rightJustify(name, numParents + name.length, ' '));
	}

	void end() {
		writeln();
	}
}
