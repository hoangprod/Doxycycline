#pragma once


class FSM {
public:
	std::function<void()> activeState; // points to the currently active state function
	FSM() {
	}
	void setState(std::function<void()> State) {
		activeState = State;
	}
	void update() {
		if (activeState != NULL) {
			activeState();
		}
	}
};

class Grinding
{
public:
	FSM Ai;
	int tick = 150;
	unsigned long long lastTick = 0;

public:

	Grinding()
	{
		const char* BotStatus = new char[100](); BotStatus = "Grindbot - Starting...";
		auto fp = std::bind(&Grinding::States, this);
		Ai.setState(fp);
	};

	~Grinding() {
		delete[] BotStatus;
	}

	void States();
	void Idle();
	void Wander();
	void Fight();
	void Bank();
	void Heal();
	void Hide();

	const char* BotStatus = NULL;

private:
	bool needHeal();
};
