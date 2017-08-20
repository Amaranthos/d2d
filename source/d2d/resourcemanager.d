module d2d.resourcemanager;

import d2d.texturecache;
import d2d.fontcache;

/**
* ResourceManager
* TODO: Move to generic cache system ??
*/
class ResourceManager {
	static private {
		TextureCache _textureCache;
		FontCache _fontCache;
	}

	static this() {
		_textureCache = new TextureCache;
		_fontCache = new FontCache;
	}

	static public TextureCache textureCache() @property { return _textureCache; }
	static public FontCache fontCache() @property { return _fontCache; }
}
