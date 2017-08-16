module d2d.templates.singleton;

/**
* Singleton(T)
*/
template Singleton(T) {
	protected static T _inst;

	static this() { _inst = new T(); }
	public static T inst() @property { return _inst; }
}
