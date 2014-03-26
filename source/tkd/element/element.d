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
	 * The parent of this element if nested within another.
	 */
	protected Element _parent;

	/**
	 * An optional identifier that overrides the generated id.
	 */
	protected string _manualIdentifier;

	/**
	 * Internal element identifier.
	 */
	protected string _elementId;

	/**
	 * The unique hash of this element.
	 */
	protected string _hash;

	/**
	 * Construct the element.
	 *
	 * Params:
	 *     parent = An optional parent of this element.
	 */
	public this(Element parent)
	{
		this._tk        = Tk.getInstance();
		this._parent    = parent;
		this._elementId = "element";
		this._hash      = this.generateHash();
	}

	/**
	 * Construct the element.
	 */
	public this()
	{
		this(null);
	}

	/**
	 * The unique id of this element.
	 *
	 * Returns:
	 *     The string id.
	 */
	public @property string id() nothrow
	{
		if (this._manualIdentifier !is null)
		{
			return this._manualIdentifier;
		}

		string parentId;

		if (this._parent !is null && this._parent.id != ".")
		{
			parentId = this._parent.id;
		}

		return parentId ~ "." ~ this._elementId ~ "-" ~ this._hash;
	}

	/**
	 * The parent element if any.
	 *
	 * Returns:
	 *     The parent element.
	 */
	public @property Element parent()
	{
		return this._parent;
	}

	/*
	 * Override the unique id of this element.
	 *
	 * Params:
	 *     identifier = The overriden identifier.
	 */
	protected void overrideGeneratedId(string identifier) nothrow
	{
		this._manualIdentifier = identifier;
	}

	/**
	 * Generate the unique hash for this element.
	 *
	 * Returns:
	 *     The string hash.
	 */
	protected string generateHash()
	{
		string text = Random(unpredictableSeed).front.to!(string);
		return hexDigest!(CRC32)(text).array.to!(string);
	}

	/**
	 * Generate the unique hash for this element.
	 *
	 * Params:
	 *     text = The format of the text to generate a hash of.
	 *     args = The arguments that the format defines (if any).
	 *
	 * Returns:
	 *     The string hash.
	 */
	protected string generateHash(A...)(string text, A args)
	{
		return hexDigest!(CRC32)(format(text, args)).array.to!(string);
	}
}
