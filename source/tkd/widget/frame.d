/**
 * Frame module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.frame;

/**
 * Imports.
 */
import std.string;
import tkd.widget.widget;

/**
 * Class representing a frame widget.
 */
class Frame : Widget
{
	/**
	 * Construct the widget.
	 *
	 * Params:
	 *     parent = An optional parent of this widget.
	 */
	this(Widget parent = null)
	{
		super(parent);

		string tkCreate = format("ttk::frame %s -borderwidth 2 -relief groove", this.id);

import std.stdio;
writefln("Geometry: %s", tkCreate);

		this._tk.eval(tkCreate);
	}
}
