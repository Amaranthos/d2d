module d2d.resourcemanager;

import d2d.texturecache;
import d2d.fontcache;

/**
* ResourceManager
*/
class ResourceManager {
	private {
		static TextureCache _textureCache;
		static FontCache _fontCache;
	}

	static this() {
		_textureCache = new TextureCache;
		_fontCache = new FontCache;
	}

	static public TextureCache textureCache() @property { return _textureCache; }
	static public FontCache fontCache() @property { return _fontCache; }
}
