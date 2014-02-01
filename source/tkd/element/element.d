/**
 * Element module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.element.element;

/**
 * Imports.
 */
import std.algorithm;
import std.array;
import std.conv;
import std.digest.crc;
import std.random;
import tkd.interpreter;

/**
 * The ui element base class.
 */
abstract class Element
{
	/**
	 * The Tk interpreter.
	 */
	protected Tk _tk;

	/**
	 * The unique hash of this element.
	 */
	protected string _hash;

	/**
	 * Internal element identifier.
	 */
	protected string _elementId;

	/**
	 * Construct the element.
	 */
	public this()
	{
		this._tk        = Tk.getInstance();
		this._hash      = this.generateHash();
		this._elementId = "element";
	}

	/**
	 * The unique id of this element.
	 *
	 * Returns:
	 *     The string id.
	 */
	public @property string id() nothrow
	{
		return this._elementId ~ "-" ~ this._hash;
	}

	/**
	 * Generate the unique hash for this element.
	 *
	 * Params:
	 *     text = The text to generate a hash of.
	 *
	 * Returns:
	 *     The string hash.
	 */
	protected string generateHash(string text = null)
	{
		if (text is null)
		{
			text = Random(unpredictableSeed).front.to!(string);
		}
		return hexDigest!(CRC32)(text).array.to!(string);
	}
}
