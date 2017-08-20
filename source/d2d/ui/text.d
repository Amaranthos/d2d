module d2d.ui.text;

//import std.stdio; // TODO: Remove dep
//import std.conv : to;
//import std.string : format, toStringz;

//import derelict.opengl3.gl3;
//import derelict.sdl2.sdl;
//import derelict.sdl2.ttf;
//import gl3n.linalg;

//import d2d.colour;
//import d2d.constants;
//import d2d.errors;
//import d2d.fontcache;
//import d2d.resourcemanager;
//import d2d.spritebatch;

///**
//* Text
//*/
//class Text {
//	private {
//		TTF_Font* _font;
//		uint _texture;
//		int _width, _height;
//	}

//	this(in string path, in string text, in int size) {
//		writeln("Called");
//		auto font = ResourceManager.fontCache.get(path, size);
//		writeln("Font: ", font);
//		auto surface = TTF_RenderUTF8_Solid(font, text.toStringz, to!SDL_Color(Colour.white));
//		scope(exit) { SDL_FreeSurface(surface); }

//		writefln("Error: %s", TTF_GetError());
//		writefln("Surface: %s", surface.pixels);

//		if(surface is null) {
//			fatalError(format("Failed to render text surface: %s", TTF_GetError())); // TODO: Should not be fatal
//		}
//		else {
//			_width = surface.w;
//			_height = surface.h;

//			glGenTextures(1, &_texture);
//			glBindTexture(GL_TEXTURE_2D, _texture);
//			glTexImage2D(GL_TEXTURE_2D, 0, surface.format.BytesPerPixel, _width, _height, 0, GL_RGBA, GL_UNSIGNED_BYTE, surface.pixels);
//		}
//	}

//	public void draw(Batcher batch, in vec2 postion, in vec2 scaling, int depth = 0,  in Colour tint = Colour.black) {
//		auto dest = vec4(postion, vec2(_width, _height));
//		//auto dest = vec4(postion, vec2(scaling.x * _width, scaling.y * _height));
//		writeln("Pos: ", dest);
//		batch.draw(dest, Constants.uvs, _texture, depth, tint);
//	}
//}
