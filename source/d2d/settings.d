module d2d.settings;

import gl3n.linalg : vec4;

/**
* Settings
*/
static class Settings {
	static {
		public auto width = 1024;
		public auto height = 768;
		public auto maxFPS = 60.0f;
		public auto vsync = VSync.Disabled;
		public auto printFPS = false;
		public auto clearColour = vec4(0.6f, 0.6f, 0.6f, 1.0f);
		public auto cameraScale = 1.0f / 2.0f;
		public auto numberAudioChannels = 100;
		public auto maxParticles = 10000;
		public auto profiling = true;
		public auto muteAudio = true;
		public auto windowName = "Hello, world....";
		public auto escapeExits = true;

		// Spatial Partitioning
		public auto gridCellSize = 128;

		// TODO: move to module system
		public auto map = "assets/maps/level0.map";
		public auto entityRadius = 16;
		public auto playerMoveSpeed = 8f;
		public auto humanMoveSpeed = 1.3f;
		public auto zombieMoveSpeed = 1.5f;
		public auto bulletRadius = 4;
		public auto playerHp = 150;
		public auto humanHp = 20;
		public auto zombieHp = 100;
	}

	enum VSync {
		Disabled,
		Enabled
	}
}
