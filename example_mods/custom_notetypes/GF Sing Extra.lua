
function onCreate()
	--Iterate over all notes
	for i = 0, getProperty('unspawnNotes.length')-1 do
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'GF Sing Extra' then
			setPropertyFromGroup('unspawnNotes', i, 'texture', 'extras'); --Change texture
			setPropertyFromGroup('unspawnNotes', i, 'gfNote', true);
		end
	end
end