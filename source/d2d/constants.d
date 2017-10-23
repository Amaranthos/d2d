module d2d.constants;

import gl3n.linalg : vec4, vec2;

/**
* Constants
*/
static class Constants {
	static public {
		enum shaderPositionLoc = 0;
		enum shaderColourLoc = 1;
		enum shaderUVLoc = 2;
		enum countVerts = 6;
		enum framerateSamples = 10;
		enum tileSize = 64;
		enum uvs = vec4(0f, 0f, 1f, 1f);
		enum milliseconds = 1000;
		enum maxProfilerSamples = 100;
		enum maxTextureRes = 4069;
		enum right = vec2(1f, 0f);

		// TODO: Move to default shaders class?
		enum defaultSpriteVertSrc =
		`#version 410

		layout(location = 0) in vec2 position;
		layout(location = 1) in vec4 colour;
		layout(location = 2) in vec2 uv;

		out vec4 fragColour;
		out vec2 fragUV;

		uniform mat4 mvp;

		void main() {
			gl_Position = mvp * vec4(position, 0, 1);
			fragColour = colour;
			fragUV = uv;
		}
		`;

		enum defaultSpriteFragSrc =
		`#version 410

		in vec4 fragColour;
		in vec2 fragUV;

		uniform sampler2D spr;

		out vec4 colour;

		void main() {
			colour = fragColour * texture(spr, fragUV);
		}
		`;

		enum defaultLightVertSrc =
		`#version 410

		layout(location = 0) in vec2 position;
		layout(location = 1) in vec4 colour;
		layout(location = 2) in vec2 uv;

		out vec4 fragColour;
		out vec2 fragUV;

		uniform mat4 mvp;

		void main() {
			gl_Position = mvp * vec4(position, 0, 1);
			fragColour = colour;
			fragUV = uv;
		}
		`;

		enum defaultLightFragSrc =
		`#version 410

		in vec4 fragColour;
		in vec2 fragUV;

		out vec4 colour;

		void main() {
			float distance = length(fragUV);
			colour = vec4(fragColour.rgb, fragColour.a * (pow(0.01, distance) - 0.01));
		}
		`;
	}
}
