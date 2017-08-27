module d2d.debugging.profiler;

public {
	import d2d.debugging.profiler.profiler;
}

static this() {
	import d2d.debugging.profiler.handlers;

	Profiler.outputHandler = new FileOutputHandler("debugging/profiler.log");
	//Profiler.outputHandler = new StdoutOutputHandler;
	//Profiler.outputHandler = new NullOutputHandler;
}
