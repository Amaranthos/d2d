module d2d.debugging.profiler.profiler;

import std.string : format;

import derelict.sdl2.sdl;

import d2d.constants;
import d2d.debugging.profiler.iprofileroutputhandler;

/**
* Profiler
*/
static class Profiler {
	public static IProfilerOutputHandler outputHandler;

	private {
		static Sample[Constants.maxProfilerSamples] samples;
		static int lastOpened = -1;
		static int numOpen = 0;
		static float rootStart = 0f;
		static float rootEnd = 0f;

		uint _index;
		int _parentIndex = -1;
	}


	public this(in string name) {
		uint newIndex = -1;

		foreach(uint i, ref sample; samples) {
			if(!sample.isValid) { newIndex = i; break; }
			else {
				if(sample.name == name) {
					assert(!sample.isOpen, "Tried to profile a sample which is already open");
					_index = i;
					_parentIndex = lastOpened;
					lastOpened = i;
					sample.numParents = numOpen;
					++numOpen;
					sample.isOpen = true;
					++sample.callCount;
					sample.start = time();
					if(_parentIndex < 0) { rootStart = sample.start; }
					return;
				}
			}
		}

		assert(newIndex >= 0, format("Profiler has no available sample slots: %s", newIndex));
		auto sample = &samples[newIndex];
		sample.isValid = true;
		sample.name = name;
		_index = newIndex;
		_parentIndex = lastOpened;
		lastOpened = newIndex;
		sample.numParents = numOpen;
		++numOpen;
		sample.isOpen = true;
		sample.callCount = 1;

		sample.total = 0f;
		sample.children = 0f;
		sample.start = time();
		if(_parentIndex < 0) { rootStart = sample.start; }
	}

	public void stop() {
		// Timing complete
		float end = time();
		auto sample = &samples[_index];
		sample.isOpen = false;
		float timeTaken = end - sample.start;

		// Add time to parents
		if(_parentIndex >= 0) {
			samples[_parentIndex].children += timeTaken;
		}
		else { rootEnd = end; }

		sample.total += timeTaken;
		lastOpened = _parentIndex;
		--numOpen;
	}

	static public void output() {
		assert(outputHandler !is null, "No IProfilerOutputHandler provided");

		outputHandler.begin;

		foreach(i, ref sample; samples) {
			if(sample.isValid) {
				double time, percentage;
				time = sample.total - sample.children;
				percentage = (time / (rootEnd - rootStart)) * 100f;

				auto total = sample.avg * sample.dataCount;
				total += percentage;
				++sample.dataCount;
				sample.avg = total / sample.dataCount;

				if(sample.min == -1 || percentage < sample.min) { sample.min = percentage; }
				if(sample.max == -1 || percentage > sample.max) { sample.max = percentage; }

				outputHandler.output(sample.min, sample.avg, sample.max, sample.callCount, sample.name, sample.numParents);

				// Reset
				sample.callCount = 0;
				sample.total = 0f;
				sample.children = 0f;
			}
		}
		rootStart = 0f;
		rootEnd = 0f;

		outputHandler.end;
	}

	static public void resetSample(in string name) {
		foreach(ref sample; samples) {
			if(sample.name == name) {
				sample.isValid = false;
				return;
			}
		}
	}

	static public void resetAll() {
		foreach(ref sample; samples) {
			sample.isValid = false;
		}
	}

	static private float time() { return SDL_GetTicks()/1000f; }
}

/**
 * Sample
 */
private struct Sample {
	bool isValid = false;
	bool isOpen;
	uint callCount;
	string name;
	float start;
	float total;
	float children;
	int numParents;
	float avg = -1f;
	float min = -1f;
	float max = -1f;
	ulong dataCount;
}
