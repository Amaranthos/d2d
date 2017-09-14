module d2d.gameobject;

import d2d.components;

/**
* GameObject
*/
class GameObject {
	private {
		//Transform _transform;
		Component[] _components;
	}

	this() {}

	/**
	* AddComponent
	*/
	public void AddComponent(Component comp) {
		_components ~= comp;
	}

	/**
	* GetComponent(T)
	*/
	public T GetComponent(T)() {

	}
}
