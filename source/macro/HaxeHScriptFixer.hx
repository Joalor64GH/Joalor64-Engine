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
 * HaxeHScriptFixer.hx
 * A macro designed to augment the Polymod HScript Macro.
 * Adds a call to `Debug.logError` to all `@:hscript` functions.
 * Previously contained code to inject additional variables; this has been contributed to Polymod instead.
 */
package macro;

using haxe.macro.ExprTools;
using haxe.macro.TypeTools;
using Lambda;

class HaxeHScriptFixer
{
	public static macro function build():Array<Field>
	{
		var cls = Context.getLocalClass().get();
		var fields:Array<Field> = Context.getBuildFields();

		var constructor_setup:Array<Expr> = null;

		var hscript_global_field_names:Array<String> = [];

		// We first make sure the class has a constructor. We can create one if it doesn't have one.
		// The constructor is needed because script loading is done there.
		if (cls.constructor == null)
		{
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

		// Find all fields with @:hscript metadata
		for (field in fields)
		{
			if (field.meta == null)
				continue;
			var scriptable_meta = field.meta.find(function(m) return m.name == ":hscript");
			if (scriptable_meta == null)
				continue;

			switch field.kind
			{
				case FFun(func):
					var return_expr = switch func.ret
					{
						case TPath({name: "Void", pack: [], params: []}):
							// Function sigture says Void, don't return anything
							macro null;
						default:
							macro return script_result;
					}

					var pathName = field.name;
					// We have to get this the hard way to avoid a macro-in-macro error.
					if (polymod.util.DefineUtil.getDefineBoolRaw('POLYMOD_USE_NAMESPACE'))
					{
						var module:String = Context.getLocalModule();
						module = StringTools.replace(module, ".", "/");
						pathName = $v{module + "/" + pathName};
					}
				default:
					Context.error("Error: The @:hscript meta is only allowed on functions", field.pos);
			}
		}

		return fields;
	}
}