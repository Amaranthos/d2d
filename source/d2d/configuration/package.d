module d2d.configuration;

public {
	import d2d.configuration.configuration;
}

static this() {
	// TODO: replace with logging
	import std.stdio;
	import jsonx;
	writeln(jsonEncode(Config));
}
