module d2d.settings;

import gl3n.linalg : vec4;

/**
* Settings
* TODO: move to mod system
*/
static class Settings {
	static {
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
}
