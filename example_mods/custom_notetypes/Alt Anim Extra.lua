
function onCreate()
	--Iterate over all notes
	for i = 0, getProperty('unspawnNotes.length')-1 do
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'Alt Anim Extra' then
			setPropertyFromGroup('unspawnNotes', i, 'texture', 'extras'); --Change texture
		end
	end
end