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
import tkd.widget.common.border;
import tkd.widget.common.height;
import tkd.widget.common.padding;
import tkd.widget.common.relief;
import tkd.widget.common.width;
import tkd.widget.relief;
import tkd.widget.widget;

/**
 * Class representing a frame widget.
 *
 *
 * Additional_Commands:
 *     These are common commands that can be used with this widget.
 *     $(P
 *         $(LINK2 ./common/border.html, border) $(BR)
 *         $(LINK2 ./common/height.html, height) $(BR)
 *         $(LINK2 ./common/padding.html, padding) $(BR)
 *         $(LINK2 ./common/relief.html, relief) $(BR)
 *         $(LINK2 ./common/width.html, width) $(BR)
 *     )
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
	 *     parent = The parent of this widget.
	 *     width = The width of the frame border.
	 *     relief = The relief style of the border.
	 *
	 * See_Also:
	 *     $(LINK2 ../element/uielement.html, tkd.element.UiElement) $(BR)
	 *     $(LINK2 ./relief.html, tkd.widget.relief) $(BR)
	 */
	public this(UiElement parent, int width = 2, string relief = Relief.groove)
	{
		super(parent);

		string tkScript = format("ttk::frame %s", this.id);
		this._tk.eval(tkScript);

		this.setBorderWidth(width);
		this.setRelief(relief);
	}

	/**
	 * Construct the widget.
	 *
	 * Params:
	 *     width = The width of the frame border.
	 *     relief = The relief style of the border.
	 *
	 * See_Also:
	 *     $(LINK2 ./relief.html, tkd.widget.relief)
	 */
	public this(int width = 2, string relief = Relief.groove)
	{
		this(null, width, relief);
	}

	/**
	 * Mixin common commands.
	 */
	mixin border;
	mixin height;
	mixin padding;
	mixin relief;
	mixin width;
}
