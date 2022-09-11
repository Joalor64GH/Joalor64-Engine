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
 * I18n.hx
 * Functionality to translate text. Powered by FireTongue.
 */
package localization;

import firetongue.FireTongue;

class I18n
{
	static final DEFAULT_LOCALE = 'en-US';
	static var tongue:FireTongue;

	public static function initLocalization(locale:String = 'en-US')
	{
		tongue = new FireTongue();
	}

	/**
	 * Fetch a string by its translation key.
	 * @param key 
	 */
	public static function t(key:String, ns:String = 'data')
	{
		var result = tongue.get(key, ns);
		trace('Translate: $ns:$key -> "$result"');
	}

	/**
	 * `<Q>`  = Standard single quotation mark ( " )
	 * `<LQ>` = Fancy left quotation mark ( “ )
	 * `<RQ>` = Fancy right quotation mark ( ” )
	 * `<C>`  = Standard comma
	 * `<N>`  = Line break
	 * `<T>`  = Tab
	 */
}