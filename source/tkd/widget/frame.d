/**
 * Widget module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.frame;

/**
 * Imports.
 */
import std.string;
import tkd.element.uielement;
import tkd.widget.widget;

/**
 * Class representing a frame widget.
 *
 * See_Also:
 *     $(LINK2 ./widget.html, tkd.widget.widget)
 */
class Frame : Widget
{
	/**
	 * Construct the widget.
	 *
	 * Params:
	 *     parent = An optional parent of this widget.
	 *
	 * See_Also:
	 *     $(LINK2 ../element/uielement.html, tkd.element.UiElement)
	 */
	public this(UiElement parent = null)
	{
		super(parent);

		string tkScript = format("ttk::frame %s -borderwidth 2 -relief groove", this.id);

		this._tk.eval(tkScript);
	}
}
