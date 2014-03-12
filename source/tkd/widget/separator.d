/**
 * Widget module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.separator;

/**
 * Imports.
 */
import std.string;
import tkd.element.uielement;
import tkd.widget.orientation;
import tkd.widget.widget;

/**
 * A separator widget displays a horizontal or vertical separator bar.
 *
 * Additional_Events:
 *     Additional events that can also be bound to using the $(LINK2 ../element/uielement.html#UiElement.bind, bind) method.
 *     $(P
 *         &lt;&lt;PrevWindow&gt;&gt;,
 *         &lt;Alt-Key&gt;,
 *         &lt;Key-F10&gt;,
 *         &lt;Key-Tab&gt;,
 *     )
 *
 * See_Also:
 *     $(LINK2 ./widget.html, tkd.widget.widget)
 */
class Separator : Widget
{
	/**
	 * Construct the widget.
	 *
	 * Params:
	 *     parent = The parent of this widget.
	 *     orientation = The orientation of the widget.
	 *
	 * See_Also:
	 *     $(LINK2 ../element/uielement.html, tkd.element.UiElement) $(BR)
	 *     $(LINK2 ./orientation.html, tkd.widget.orientation) for orientations.
	 */
	public this(UiElement parent, string orientation = Orientation.horizontal)
	{
		super(parent);
		this._elementId     = "separator";

		this._tk.eval("ttk::separator %s -orient %s", this.id, orientation);
	}

	/**
	 * Construct the widget.
	 *
	 * Params:
	 *     orientation = The orientation of the widget.
	 *
	 * See_Also:
	 *     $(LINK2 ./orientation.html, tkd.widget.orientation) for orientations.
	 */
	public this(string orientation = Orientation.horizontal)
	{
		this(null, orientation);
	}
}
