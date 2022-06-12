local Nps = 0
local NoteHit = false;
function onStepHit()
    if NoteHit == true then
        Nps = Nps - 2 * 4 -- math is funny
    end    
end

function onUpdatePost(elapsed)
    local ratePercent = getProperty('ratingPercent') -- no more round!

    local ratingFull = math.max(ratePercent * 100, 0)
    local ratingFullAsStr = string.format("%.2f", ratingFull)
    -- ratingFull and ratingFullAsStr were taken from i-winxd Complex Accuracy, so shout out to him
    -- also i don't know if this is accurate accuracy

    local BeforeScore = 'Score: '..score..' // Combo Breaks: '..misses..' // Accuracy: '..ratingName..' // KPS: '..Nps
    local FinalScore = 'Score: '..score..' // Combo Breaks: '..misses..' // Accuracy: '..ratingName..' ('..ratingFullAsStr..'%) // Rank: '..ratingFC..' // KPS: '..Nps

    if ratingName == '?' then
        setTextString('scoreTxt', BeforeScore)
    else
        setTextString('scoreTxt', FinalScore)  
    end

    if Nps < 0 then
        Nps = 0
        NoteHit = false;
    end   
end
    
function goodNoteHit(id, direction, noteType, isSustainNote)
    if not isSustainNote then
        Nps = Nps + 1
        NoteHit = false;
    end

    ezTimer('drain', 1, function()
        NoteHit = true;
    end)  
end

timers = {}
function ezTimer(tag, timer, callback) -- Better
    table.insert(timers,{tag, callback})
    runTimer(tag, timer)
end

function onTimerCompleted(tag)
    for k,v in pairs(timers) do
        if v[1] == tag then
            v[2]()
        end
    end
end