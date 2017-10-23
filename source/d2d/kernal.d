module d2d.kernal;

import std.stdio;

import derelict.sdl2.sdl;

import d2d;

/**
* Kernal
*/
abstract class Kernal {
	protected {
		List _viewList;
		View _currentView = null;
		AppState _currentState = AppState.Running;
		Window _window = new Window;
		FPSLimiter _fpsLimiter = new FPSLimiter;
	}

	/**
	* run
	*/
	public void run() {
		scope(exit) { exit(); d2d.quit; }
		init();

		while(_currentState != AppState.Exit) {
			{
				auto profiler = new Profiler("Kernal main loop");
				scope(exit) { profiler.stop; }
				_fpsLimiter.begin;

				DeltaTime.update;

				events();
				update();
				draw();

				_fpsLimiter.end;
				_fpsLimiter.print;

			}
			Profiler.output;
			stdout.flush;
		}
	}

	/**
	* onInit
	*/
	abstract public void onInit();

	/**
	* addViews
	*/
	abstract public void addViews();

	/**
	* onExit
	*/
	abstract public void onExit();

	/**
	* update
	*/
	private void update() {
		if(_currentView is null) { _currentState = AppState.Exit; return; }

		final switch(_currentView.state) with (ViewState) {
			case None:
				break;

			case Running:
				_currentView.update;
				break;

			case ChangeNext:
				_currentView.onExit;
				_currentView = _viewList.next;
				if(_currentView !is null) { _currentView.onEntry; }
				break;

			case ChangePrevious:
				_currentView.onExit;
				_currentView = _viewList.previous;
				if(_currentView !is null) { _currentView.onEntry; }
				break;

			case ExitApp:
				_currentState = AppState.Exit;
				break;
		}
	}

	/**
	* draw
	*/
	private void draw() {
		if(_currentView !is null && _currentView.state == ViewState.Running) {
			_currentView.draw;
		}

		_window.swapBuffer;
	}

	/**
	* init
	*/
	private void init() {
		d2d.init;

		_window.create(Config.window.title, Config.window.width, Config.window.height);
		_viewList = new List(this);

		AudioEngine.init;
		DeltaTime.init;

		onInit();
		addViews();

		_currentView = _viewList.current;
		if(_currentView !is null) { _currentView.onEntry; }
	}

	/**
	* exit
	*/
	private void exit() {
		onExit();

		if(_currentView !is null) { _currentView.onExit; }

		ParticleEngine.deinit;
		AudioEngine.deinit;

		delete _fpsLimiter;
		delete _viewList;
		delete _window;
	}

	/**
	* events
	*/
	private void events() {
		auto profiler = new Profiler("App events");
		scope(exit) { profiler.stop; }

		SDL_Event event;
		Input.update();
		while(SDL_PollEvent(&event)) {
			Input.events(event);
			if(_currentView !is null) { _currentView.events(event); }
			switch(event.type) {
				case SDL_QUIT:
					_currentState = AppState.Exit;
					break;

				default: break;
			}
		}

		if(Config.debugging.escapeExits && Input.get(SDLK_ESCAPE)) { _currentState = AppState.Exit; }
	}

	public void currentState(AppState value) @property { _currentState = value; }
}
