module d2d.debugging.profiler.handlers.nulloutputhandler;

import std.stdio : writefln;

import d2d.debugging.profiler.profiler;
import d2d.debugging.profiler.iprofileroutputhandler;

/**
* NullOutputHandler
*/
class NullOutputHandler : IProfilerOutputHandler {
	void begin() {}
	void output(in float min, in float avg, in float max, in int callCount, in string name, in int numParents) {}
	void end() {}
}
