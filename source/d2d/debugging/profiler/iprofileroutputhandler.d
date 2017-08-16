module d2d.debugging.profiler.iprofileroutputhandler;

interface IProfilerOutputHandler {
	void begin();
	void output(in float min, in float avg, in float max, in int callCount, in string name, in int numParents);
	void end();
}
