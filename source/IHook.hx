/*
 * Apache License, Version 2.0
 *
 * Copyright (c) 2021 MasterEric
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at:
 *     http://www.apache.org/licenses/LICENSE-2.0
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/*
 * IHook.hx
 * An interface which can be added to a class, which indicates that one or more functions on it are script hooks.
 * A compile time macro will apply logic as needed to ensure scripts are loaded and run.
 */
package;

import polymod.hscript.HScriptable;

@:autoBuild(macro.HaxeHScriptFixer.build()) // This macro adds a `Debug.logError` call that occurs if a script error occurs.
// ALL of these values are added to ALL scripts in the child classes.
@:hscript({
	context: [Debug, FlxG, FlxSprite, Math, Paths, Std]
})
interface IHook extends HScriptable
{
}
