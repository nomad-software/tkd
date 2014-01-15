/**
 * Widget module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.element.widget.widget;

/**
 * Imports.
 */
import std.string;
import tkd.element.element;
import tkd.element.widget.cursor;

/**
 * The widget base class.
 */
abstract class Widget : Element
{
	/**
	 * Construct the widget.
	 *
	 * Params:
	 *     parent = An optional parent of this widget.
	 */
	this(Element parent = null)
	{
		super(parent);
	}

	/**
	 * Get the widget's assigned class.
	 *
	 * Returns:
	 *     A Tk class string.
	 */
	public string getClass()
	{
		this._tk.eval(format("%s cget -class", this.id));
		return this._tk.getResult();
	}

	/**
	 * Set the widget's cursor.
	 *
	 * Params:
	 *     cursor = A valid widget cursor.
	 */
	public void setCursor(Cursor cursor)
	{
		this._tk.eval(format("%s configure -cursor %s", this.id, cursor));
	}

	/**
	 * Get the widget's assigned cursor.
	 *
	 * Returns:
	 *     A Tk cursor string if any.
	 */
	public string getCursor()
	{
		this._tk.eval(format("%s cget -cursor", this.id));
		return this._tk.getResult();
	}

	/**
	 * Check if the widget can recieve focus during keyboard traversal.
	 *
	 * Returns:
	 *     A Tk class string if any.
	 */
	public string canFocus()
	{
		this._tk.eval(format("%s cget -takefocus", this.id));
		return this._tk.getResult();
	}

	/**
	 * Get the widget's assigned style.
	 *
	 * Returns:
	 *     A Tk style string if any.
	 */
	public string getStyle()
	{
		this._tk.eval(format("%s cget -style", this.id));
		return this._tk.getResult();
	}

	/**
	 * Geometry method for placing the widget onto the interface.
	 */
	public void pack()
	{
		string tkScript = format("pack %s -padx 10 -pady 10", this.id);

import std.stdio;
writefln("Geometry: %s", tkScript);

		this._tk.eval(tkScript);
	}
}
