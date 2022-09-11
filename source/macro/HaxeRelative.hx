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
 * HaxeRelative.hx
 * Add methods to an FlxObject that allow it to be positioned and rotated relative to a parent.
 */
package macro;

class HaxeRelative
{
	public static macro function build():Array<Field>
	{
		var cls:haxe.macro.Type.ClassType = Context.getLocalClass().get();
		var fields:Array<Field> = Context.getBuildFields();

		if (!checkSuperclass(cls))
		{
			return fields;
		}

		// Context.info('${cls.name}: Implementing IRelative...', cls.pos);

		// Create properties which additionally run this code when the updatePosition function when set.
		var propertyBody = [macro this.updatePosition()];
		fields = fields.concat(MacroUtil.buildProperty("parent", macro:flixel.FlxObject, null, null, propertyBody, true));
		fields = fields.concat(MacroUtil.buildProperty("relativeX", macro:Float, null, null, propertyBody, true));
		fields = fields.concat(MacroUtil.buildProperty("relativeY", macro:Float, null, null, propertyBody, true));
		fields = fields.concat(MacroUtil.buildProperty("relativeAngle", macro:Float, null, null, propertyBody, true));

		var updatePosBody = macro
			{
				if (this.parent != null)
				{
					// Set the absolute X and Y relative to the parent.
					this.x = this.parent.x + this.relativeX;
					this.y = this.parent.y + this.relativeY;
					this.angle = this.parent.angle + this.relativeAngle;
				}
				else
				{
					this.x = this.relativeX;
					this.y = this.relativeY;
				}
			};
		fields.push(MacroUtil.buildFunction("updatePosition", [updatePosBody], false, false));

		return fields;
	}

	static function checkSuperclass(cls:haxe.macro.Type.ClassType)
	{
		// Superclasses need to be checked recursively.
		if (cls.superClass != null)
		{
			var superCls = cls.superClass.t.get();
			for (field in superCls.fields.get())
			{
				// Parent already added, return false.
				if (field.name == 'parent')
					return false;
			}
			// Else, we need to check for the superclass's superclass.
			return checkSuperclass(superCls);
		}
		else
		{
			// No superclass, parent needs to be added. Return true;
			return true;
		}
	}
}