module d2d.constants;

import gl3n.linalg : vec4, vec2;

/**
* Constants
*/
static class Constants {
	static {
		public enum shaderPositionLoc = 0;
		public enum shaderColourLoc = 1;
		public enum shaderUVLoc = 2;
		public enum countVerts = 6;
		public enum framerateSamples = 10;
		public enum tileSize = 64;
		public enum uvs = vec4(0f, 0f, 1f, 1f);
		public enum milliseconds = 1000;
		public enum maxProfilerSamples = 100;
		public enum maxTextureRes = 4069;
		public enum right = vec2(1f, 0f);

		// TODO: Move to default shaders class?
		public enum defaultSpritVertSrc =
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

		public enum defaultSpriteFragSrc =
		`#version 410

		in vec4 fragColour;
		in vec2 fragUV;

		uniform sampler2D spr;

		out vec4 colour;

		void main() {
			colour = fragColour * texture(spr, fragUV);
		}
		`;

		public enum defaultLightVertSrc =
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

		public enum defaultLightFragSrc =
		`#version 410

		in vec4 fragColour;
		in vec2 fragUV;

		out vec4 colour;

		void main() {
			float distance = length(fragUV);
			colour = vec4(fragColour.rgb, fragColour.a * (1.0 - distance);
		}
		`;
	}
}
