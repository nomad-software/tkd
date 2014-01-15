/**
 * Button module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.element.widget.button;

/**
 * Imports.
 */
import std.string;
import tkd.element.element;
import tkd.element.widget.widget;

/**
 * Class representing a button widget.
 */
class Button : Widget
{
	/**
	 * Construct the widget.
	 *
	 * Params:
	 *     parent = An optional parent of this widget.
	 *     text = The text of the button.
	 */
	this(Element parent = null, string text = null)
	{
		super(parent);

		string tkScript = format("ttk::button %s -text \"%s\"", this.id, text);

import std.stdio;
writefln("Geometry: %s", tkScript);

		this._tk.eval(tkScript);
	}
}
