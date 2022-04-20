
function onCreate()
	--Iterate over all notes
	for i = 0, getProperty('unspawnNotes.length')-1 do
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'No Anim Space' then
			setPropertyFromGroup('unspawnNotes', i, 'texture', 'space'); --Change texture
			setPropertyFromGroup('unspawnNotes', i, 'noAnimation', true);
		end
	end
end