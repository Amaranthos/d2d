// FIXME: Not working, porbably use a ui library instead

module d2d.font;

//import std.stdio;
//import std.conv : to;

//import derelict.sdl2.ttf;
//import derelict.sdl2.sdl;
//import derelict.opengl3.gl3;
//import gl3n.linalg : vec4, vec2, vec4i;

//import d2d.colour;
//import d2d.constants;
//import d2d.errors;
//import d2d.math;
//import d2d.spritebatch;

///**
//* Font
//*/
//class Font {
//	private {
//		int _start, _length, _height;
//		CharGlyph[] _glyphs;
//		uint _texture;
//	}

//	this(in string path, int size, char cs = cast(char)32, char ce = cast(char)126) {
//		if(!TTF_WasInit()) { TTF_Init(); }

//		TTF_Font* font = TTF_OpenFont(path.ptr, size);
//		if(font is null) { fatalError("Failed to open font: " ~ path); } // FIXME: Shouldn't be fatal?

//		_height = TTF_FontHeight(font);
//		_start = cs;
//		_length = ce - cs + 1;
//		auto padding = size / 8;

//		auto glyphs = new vec4i[_length];
//		int index = 0;
//		foreach(ushort c; cs..ce) {
//			int x, y, z, w, adv;
//			TTF_GlyphMetrics(font, c, &x, &z, &y, &w, &adv);
//			glyphs[index].z = z - x;
//			glyphs[index].x = 0;
//			glyphs[index].w = w - y;
//			glyphs[index].y = 0;
//			writefln("char: %s, glyph: %s", cast(char)c, glyphs[index]);
//			index++;
//		}

//		int rows = 1;
//		int w, h;
//		int bestWidth = 0, bestHeight = 0;
//		int area = Constants.maxTextureRes * Constants.maxTextureRes;
//		int bestRows = 0;

//		int[][] bestPartition = null;
//		while(rows <= _length) {
//			h = rows * (padding + _height) + padding;
//			auto gr = createRows(glyphs, _length, rows, padding, w);

//			w = closestPow2(w);
//			h = closestPow2(h);

//			if(w > Constants.maxTextureRes || h > Constants.maxTextureRes) {
//				++rows;
//				delete gr;
//				continue;
//			}

//			if(area >= w * h) {
//				if(bestPartition !is null) { delete bestPartition; }
//				bestPartition = gr;
//				bestWidth = w;
//				bestHeight = h;
//				bestRows = rows;
//				area = bestWidth * bestHeight;
//				++rows;
//			}
//			else {
//				delete gr;
//				break;
//			}
//		}


//		if(bestPartition is null) { fatalError("Failed to produce a texture from " ~ path ~ ". Trying lowering resolution"); }

//		writefln("width: %s, height: %s, area: %s, partition: %s", bestWidth, bestHeight, area, bestPartition);

//		// Create gl texture
//		glGenTextures(1, &_texture);
//		glBindTexture(GL_TEXTURE_2D, _texture);
//		glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, bestWidth, bestHeight, 0, GL_RGBA, GL_UNSIGNED_BYTE, null);

//		// Draw
//		try {
//			int ly = padding;
//			foreach(ri; 0..bestRows) {
//				int lx = padding;
//				foreach(ci; 0..bestPartition[ri].length) {
//					int gi = bestPartition[ri][ci];
//					//writeln(cast(char)(cs + gi));

//					SDL_Surface* surface = TTF_RenderGlyph_Blended(font, cast(ushort)(cs + gi), cast(SDL_Color)Colour.white);

//					if(surface is null) {
//						//import std.string : format; import std.conv : to;
//						//fatalError(format("Unable to create a SDL_Surface for font: %s character: %s error: %s", path, to!char(cs + gi), to!string(TTF_GetError())));
//						surface = TTF_RenderGlyph_Blended(font, to!ushort(' '), to!SDL_Color(Colour.white));
//					}

//					auto pixels = cast(ubyte*)(surface.pixels);
//					int cp = surface.w * surface.h * 4;
//					for(int i = 0; i < cp; i += 4) {
//						//writefln("i: %s, cp: %s", i, cp);
//						//float a = 0f;
//						//if(pixels[i + 3] !is null) { a = pixels[i + 3] / 255f; }
//						try {
//							float a = pixels[i + 3] / 255f;
//							pixels[i] = cast(ubyte)(cast(float)(pixels[i]) * a);
//							pixels[i + 1] = pixels[i];
//							pixels[i + 2] = pixels[i];
//						}
//						catch(Exception e) {
//							//writeln("Exception at: ", i, " length: ", cp, " character: ", cast(char)(cs + gi));
//						}
//					}

//					glTexSubImage2D(GL_TEXTURE_2D, 0, lx, bestHeight - ly - 1 - surface.h, surface.w, surface.h, GL_BGRA, GL_UNSIGNED_BYTE, surface.pixels);
//					glyphs[gi].x = lx;
//					glyphs[gi].y = ly;
//					glyphs[gi].z = surface.w;
//					glyphs[gi].w = surface.h;

//					SDL_FreeSurface(surface);
//					surface = null;

//					lx += glyphs[gi].z + padding;
//				}
//				lx += _height + padding;
//			}
//		}
//		catch(Exception e) {
//			writeln("Exception: %s", e);
//		}

//		auto rs = padding - 1;
//		auto whiteSqr = new int[rs * rs];
//		whiteSqr[] = 0xffffffff;

//		glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, rs, rs, GL_RGBA, GL_UNSIGNED_BYTE, whiteSqr.ptr);
//		delete whiteSqr;
//		whiteSqr = null;

//		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
//		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
//		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
//		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);

//		try {
//			_glyphs = new CharGlyph[_length + 1];
//			foreach(i; 0.._length) {
//				_glyphs[i].character = cast(char)(cs + i);
//				_glyphs[i].size = vec2(glyphs[i].z, glyphs[i].w);
//				_glyphs[i].uvs = vec4(
//					  glyphs[i].x / to!float(bestWidth)
//					, glyphs[i].y / to!float(bestHeight)
//					, glyphs[i].z / to!float(bestWidth)
//					, glyphs[i].w / to!float(bestHeight)
//				);
//			}
//		}
//		catch(Exception e) {
//			writeln("Exception: ", e);
//		}

//		_glyphs[_length].character = ' ';
//		_glyphs[_length].size = _glyphs[0].size;
//		_glyphs[_length].uvs = vec4(0, 0, rs / to!float(bestWidth), rs / to!float(bestHeight));

//		writefln("%(%s\n%)", _glyphs);

//		glBindTexture(GL_TEXTURE_2D, 0);
//		delete glyphs;
//		delete bestPartition;
//		TTF_CloseFont(font);
//	}

//	public void dispose() {
//		if(_texture != 0) { glDeleteTextures(1, &_texture); _texture = 0; }
//		if(_glyphs !is null) { delete _glyphs; _glyphs = null; }
//	}

//	public vec2 measure(in string s) {
//		auto size = vec2(0, _height);
//		float cw = 0;
//		foreach(c; s) {
//		//for(int si = 0; s[si] != 0; ++si) {
//			//char c = s[si];
//			if(c == '\n') {
//				size.y += _height;
//				if(size.x < cw) { size.x = cw; }
//				cw = 0;
//			}
//			else {
//				int gi = c - _start;
//				if(gi < 0 || gi >= _length) { gi = _length; }
//				cw += _glyphs[gi].size.x;
//			}
//		}

//		if(size.x < cw) { size.x = cw; }
//		return size;
//	}

//	public void draw(Batcher batch, in string text, vec2 postion, vec2 scaling, float depth, Colour tint = Colour.white, Justification justify = Justification.Left) {
//		auto tp = postion;

//		final switch(justify) with (Justification) {
//			case Left:
//				break;

//			case Right:
//				tp.x -= measure(text).x * scaling.x;
//				break;

//			case Middle:
//				tp.x -= measure(text).x * scaling.x / 2;
//				break;
//		}
//		try {
//			foreach(c; text) {
//				if(c == '\n') {
//					tp.y += _height * scaling.y;
//					tp.x = postion.x;
//				}
//				else {
//					int gi = c - _start;
//					if(gi < 0 || gi >= _length) { gi = _length; }
//					auto dest = vec4(tp, vec2(_glyphs[gi].size.x * scaling.x, _glyphs[gi].size.y * scaling.y));
//					import d2d.resourcemanager;

//					//writefln("char: %s, dest: %s, uvs: %s, index: %s", c, dest, _glyphs[gi].uvs, gi);
//					//batch.draw(dest, Constants.uvs, ResourceManager.textureCache.get("assets/imgs/circle.png").id, depth, Colour.white);
//					batch.draw(dest, Constants.uvs, _texture, depth, tint);
//					//batch.draw(dest, _glyphs[gi].uvs, _texture, depth, tint);
//					tp.x += _glyphs[gi].size.x * scaling.x;
//				}
//			}
//			//batch.draw(vec4(tp, 1f, 1f), Constants.uvs, _texture, depth, tint);
//		}
//		catch(Exception e) {
//			writeln("Exception: ", e.msg);
//		}
//	}

//	static private int[][] createRows(ref vec4i[] rects, int length, int r, int padding, out int w) {
//		auto ret = new int[][r];
//		auto cw = new int[r];
//		foreach(i; 0..r) {
//			cw[i] = padding;
//		}

//		foreach(i; 0..length) {
//			int ri = 0;
//			foreach(rii; 1..r) {
//				if(cw[rii] < cw[ri]) { ri = rii; }
//			}

//			cw[ri] += rects[i].z + padding;
//			ret[ri] ~= i;
//		}

//		w = 0;
//		foreach(i; 0..r) {
//			if(cw[i] > w) { w = cw[i]; }
//		}

//		return ret;
//	}

//	public int height() const @property { return _height; }
//}

///**
// * CharGlyph
// */
//struct CharGlyph {
//	char character;
//	vec4 uvs;
//	vec2 size;
//}

//enum Justification {
//	  Left
//	, Middle
//	, Right
//}
