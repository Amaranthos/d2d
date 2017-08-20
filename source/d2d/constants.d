module d2d.constants;

import gl3n.linalg : vec4;

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
	}
}
