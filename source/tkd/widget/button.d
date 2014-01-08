/**
 * Button module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.button;

/**
 * Imports.
 */
import std.string;
import tkd.widget.widget;

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
	this(Widget parent, string text = null)
	{
		super(parent);

		string tkCreate = format("ttk::button %s -text \"%s\"", this.id, text);

import std.stdio;
writefln("Geometry: %s", tkCreate);

		this._tk.eval(tkCreate);
	}

	// public void setText(string text)
	// {
	// 	this._tkOptions["-text"] = format("\"%s\"", text);
	// }
}
