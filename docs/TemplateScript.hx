function create()
{
	// before characters are generated on PlayState
}

function postCreate()
{
	// after characters are generated on PlayState
}

function destroy()
{
	// after playstate ends
}

function update(elapsed:Float)
{
	// during playstate's update function
}

function postUpdate()
{
	// after playstate's update function
}

function goodNoteHit(coolNote:Note, character:Character)
{
	// called when you hit a note on PlayState
}

function noteMiss(strumNote:Note)
{
	// called when you miss a note on PlayState
}

function startCountdown()
{
	// when the countdown starts
}

function countdownTick(swagCounter:Int)
{
	// when the countdown is ticking (e.g: three(0), two(1), one(2), go(3))
}

function startSong()
{
	// when the song starts
}

function stepHit(curStep:Int)
{
	// when a song step is hit
}

function beatHit(curBeat:Int)
{
	// when a song beat is hit
}

function doGameOverCheck()
{
	// on PlayState's game over check
}

function endSong()
{
	// when a song is ending or ended
}

function completeTween()
{
	// when a scripted tween is finished
}

function pauseGame()
{
	// when you pause the game
}

function closeSubState()
{
	// when a substate (usually the pause menu) is closed
}

function gameOverBegins()
{
	// when you die and the game over substate begins
}

function resyncVocals()
{
	// when a song's vocal track is resynched on Conductor
}