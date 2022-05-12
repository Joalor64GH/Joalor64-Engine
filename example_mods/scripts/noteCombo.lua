local lastMustHit = false
local noteHits = 0

function onCreatePost()
    lastMustHit = mustHitSection
    precacheSound('confirmMenu')

    local x = defaultBoyfriendX / 10 + getProperty('boyfriend.x') / 4
    local y = defaultBoyfriendY / 10 + getProperty('boyfriend.y') / 6 + 150
    if getPropertyFromClass('PlayState', 'isPixelStage') or
        getProperty('camGame.zoom') > 1 then
        x = x - 175
        y = y / 1.5
    end
    makeAnimatedLuaSprite('noteCombo', 'noteCombo', x, y)
    setScrollFactor('noteCombo', 0.5, 0.5)

    addAnimationByPrefix('noteCombo', 'appear', 'appear', 24, false)
    addAnimationByPrefix('noteCombo', 'disappear', 'disappear', 40, false)

    setProperty('noteCombo.visible', false)
    setProperty('noteCombo.active', false)
    setProperty('noteCombo.antialiasing',
                getPropertyFromClass('ClientPrefs', 'globalAntialiasing'))

    addLuaSprite('noteCombo', true)
end

function playAnim(anim, force)
    if force == nil then force = false end
    objectPlayAnimation('noteCombo', anim, force)

    local ox, oy = 0, 0
    if anim == 'disappear' then ox = -150 end

    setProperty('noteCombo.offset.x', ox)
    setProperty('noteCombo.offset.y', oy)
end

function onUpdate()
    if lastMustHit ~= mustHitSection then
        lastMustHit = mustHitSection
        if not lastMustHit and noteHits > 6 and
            (curBeat % 4 == 6 or curBeat % 4 == 0) then
            noteHits = 0
            playSound('confirmMenu', 0.425)
            setProperty('noteCombo.visible', true)
            setProperty('noteCombo.active', true)
            playAnim('appear', true)
        end
    end

    if getProperty('noteCombo.animation.finished') then
        local ateUrFrame = getProperty('noteCombo.animation.curAnim.name')
        if ateUrFrame == 'appear' then
            playAnim('disappear')
        elseif ateUrFrame == 'disappear' then
            setProperty('noteCombo.visible', false)
            setProperty('noteCombo.active', false)
        end
    end
end

function goodNoteHit(id, direction, noteType, isSustainNote)
    if not isSustainNote then noteHits = noteHits + 1 end
end
