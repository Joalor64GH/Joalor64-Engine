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
 * MacroUtil.hx
 * Utility functions which are useful for macros.
 * Call these ONLY from within a macro or your code won't compile!
 */
package macro;

import haxe.macro.Context;
import haxe.macro.Expr;

class MacroUtil
{
	#if macro
	/**
	 * Create a constructor field for an object class using one or more Exprs as the body.
	 * @param body The body of the constructor.
	 * @return The newly formed constructor.
	 */
	public static function buildConstructor(body:Array<Expr>):Field
	{
		return ({
			name: "new",
			access: [APublic],
			pos: Context.currentPos(),
			kind: FFun({
				args: [],
				expr: macro $b{body},
				params: [],
				ret: null
			})
		});
	}

	public static function buildVariable(name:String, varType:ComplexType, defaultValue:Expr, isPublic:Bool = true, isStatic:Bool = false):Field
	{
		var access = [];
		if (isPublic)
			access.push(Access.APublic);
		if (isStatic)
			access.push(Access.AStatic);

		return {
			name: name,
			access: access,
			kind: FieldType.FVar(varType, defaultValue),
			pos: Context.currentPos(),
		}
	}

	/**
	 * Create an instance of the given ClassType.
	 */
	public static function createInstance(e:haxe.macro.Type.ClassType)
	{
		var path = buildTypePath(e);

		// Create a new instance from the path/type here.
		return macro new $path();
	}

	/**
	 * Build a TypePath from the given ClassType.
	 */
	public static function buildTypePath(e:haxe.macro.Type.ClassType):haxe.macro.TypePath
	{
		return {
			name: e.name,
			sub: e.module == e.name ? null : e.name,
			pack: e.pack
		};
	}

	/**
	 * This one is kind of complex but it does a lot of work for you.
	 * This macro will:
	 * Create a property `name`.
	 * Create a function `get_<name>`, that runs the macro in `getFnBody`, then returns the new value.
	 *   Pass `[]` to use the default getter, pass `null` to make the getter inaccessible.
	 * Create a function `set_<name>`, with the proper argument, that sets the property, runs the macro in `getFnBody`, then returns the new value.
	 *   Pass `[]` to use the default setter, pass `null` to make the setter inaccessible.
	 * 
	 * @param name The name of the property to generate.
	 * @param getFnBody Additional lines to add to the getter function. For default behavior, pass []. 
	 * @param setFnBody Additional lines to add to the setter function. For default behavior, pass [].
	 * @return All the fields to add to the class.
	 */
	public static function buildProperty(name:String, varType:ComplexType, defaultValue:Expr, getFnBody:Array<Expr> = null, setFnBody:Array<Expr> = null,
			isPublic:Bool = true):Array<Field>
	{
		var results:Array<Field> = [];

		var getter:String;
		if (getFnBody == null)
		{
			getter = 'null';
		}
		else if (getFnBody == [])
		{
			getter = 'default';
		}
		else
		{
			getter = 'get';
			var getterBody = getFnBody.copy().concat([macro return this.$name]);

			results.push(buildFunction('get_${name}', getterBody, false, false));
		}

		var setter:String;
		if (setFnBody == null)
		{
			setter = 'null';
		}
		else if (setFnBody == [])
		{
			setter = 'default';
		}
		else
		{
			setter = 'set';

			var setterBody = [macro this.$name = input].concat(setFnBody).concat([macro return this.$name]);
			var setterArgs = [
				{
					name: 'input',
					type: varType,
				}
			];

			results.push(buildFunction('set_${name}', setterBody, false, false, setterArgs));
		}

		var access = [];
		if (isPublic)
			access.push(Access.APublic);

		results.unshift({
			access: access,
			name: name,
			kind: FProp(getter, setter, varType, defaultValue),
			pos: Context.currentPos(),
			// Specify isVar to force a physical variable even when property getter/setter are modified.
			meta: [{name: 'isVar', pos: Context.currentPos()}]
		});

		return results;
	}

	public static function buildFunction(name:String, body:Array<Expr>, isPublic:Bool = true, isStatic:Bool = false,
			functionArgs:Array<FunctionArg> = null):Field
	{
		var access = [];
		if (isPublic)
			access.push(Access.APublic);
		if (isStatic)
			access.push(Access.AStatic);

		return {
			name: name,
			access: access,
			pos: Context.currentPos(),
			kind: FFun({
				args: functionArgs == null ? [] : functionArgs,
				expr: macro $b{body},
				params: [],
				ret: null
			})
		}
	}
	#end
}