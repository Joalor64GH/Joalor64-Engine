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
 * HaxeSingleton.hx
 * Performs a macro that creates an instance of the class and append the value as a static property `instance`.
 * @see https://en.wikipedia.org/wiki/Singleton_pattern
 * @see https://code.haxe.org/category/macros/build-static-field.html
 * @see https://community.haxe.org/t/initialize-class-instance-from-expr-in-macro/521
 */
package macro;

using haxe.macro.ExprTools;
using haxe.macro.TypeTools;
using Lambda;

class HaxeSingleton
{
	public static macro function build():Array<Field>
	{
		var cls:haxe.macro.Type.ClassType = Context.getLocalClass().get();
		var fields:Array<Field> = Context.getBuildFields();

		// We first make sure the class has a constructor.
		if (cls.constructor == null)
		{
			// Context.info('Adding constructor to class ${cls.name}...', cls.pos);

			var constBody:Array<Expr> = [];

			var parentCls = cls.superClass.t.get();
			if (parentCls != null)
			{
				var parentCons = parentCls.constructor;
				if (parentCons != null)
				{
					var constructorCall = macro
						{
							super();
						};
					constBody.push(constructorCall);
				}
				else
				{
					Context.error('Class ${cls.name} needs a constructor, or a parent with a constructor!', cls.pos);
				}
			}
			else
			{
				Context.error('Class ${cls.name} needs a constructor, or a parent with a constructor!', cls.pos);
			}

			// This constructor takes zero arguments or parameters, and only calls the superClass constructor
			// with zero arguments.
			fields.push(MacroUtil.buildConstructor(constBody));
		}

		// Context.info('Adding instance to class ${cls.name}...', cls.pos);
		// Create a public static variable called 'instance'.
		// WARNING: There is a bug where this initializes the instance too early for Lime assets to be loaded in.
		fields.push(MacroUtil.buildVariable("instance", TPath(MacroUtil.buildTypePath(cls)), MacroUtil.createInstance(cls), true, true));

		return fields;
	}
}