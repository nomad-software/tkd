/**
 * Element module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.element.store;

/**
 * Imports.
 */
import std.string;

/**
 * The store struct.
 */
struct Store(T)
{
	/**
	 * Storage for all items.
	 */
	private T[string] _items;

	/**
	 * Handle storing items as properties of this struct. If a property 
	 * doesn't exist when assigning a item to it, this method is called.
	 *
	 * Params:
	 *     name = The property name of the accessed item.
	 *     item = The item assigned to the property name.
	 *     file = The file name where this action occurred for error reporting.
	 *     line = The line number where this action occurred for error reporting.
	 *
	 * See_Also:
	 *     http://dlang.org/operatoroverloading.html#Dispatch
	 */
	private void opDispatch(string name)(T item, string file = __FILE__, size_t line = __LINE__)
	{
		if (name in this._items)
		{
			throw new Exception(format("%s with id '%s' already exists.", T.stringof, name), file, line);
		}

		this._items[name] = item;
	}

	/**
	 * Handle retrieving items as properties of this struct.
	 *
	 * Params:
	 *     name = The property name of the accessed item.
	 *     file = The file name where this action occurred for error reporting.
	 *     line = The line number where this action occurred for error reporting.
	 *
	 * Returns:
	 *     The item matching the property name.
	 *
	 * See_Also:
	 *     http://dlang.org/operatoroverloading.html#Dispatch
	 */
	private T opDispatch(string name)(string file = __FILE__, size_t line = __LINE__)
	{
		if (name in this._items)
		{
			return this._items[name];
		}
		throw new Exception(format("%s with id '%s' does not exist.", T.stringof, name), file, line);
	}
}
