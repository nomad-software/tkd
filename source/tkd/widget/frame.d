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
import tkd.element.uielement;
import tkd.widget.common.border;
import tkd.widget.common.height;
import tkd.widget.common.padding;
import tkd.widget.common.relief;
import tkd.widget.common.width;
import tkd.widget.reliefstyle;
import tkd.widget.widget;

/**
 * Class representing a frame widget.
 *
 *
 * Additional_Commands:
 *     These are common commands that can be used with this widget.
 *     $(P
 *         $(LINK2 ./common/border.html, Border) $(BR)
 *         $(LINK2 ./common/height.html, Height) $(BR)
 *         $(LINK2 ./common/padding.html, Padding) $(BR)
 *         $(LINK2 ./common/relief.html, Relief) $(BR)
 *         $(LINK2 ./common/width.html, Width) $(BR)
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
	 *     $(LINK2 ./reliefstyle.html, tkd.widget.reliefstyle) $(BR)
	 */
	public this(UiElement parent, int width = 2, string relief = ReliefStyle.groove)
	{
		super(parent);

		this._tk.eval("ttk::frame %s", this.id);

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
	 *     $(LINK2 ./reliefstyle.html, tkd.widget.reliefstyle) $(BR)
	 */
	public this(int width = 2, string relief = ReliefStyle.groove)
	{
		this(null, width, relief);
	}

	/**
	 * Mixin common commands.
	 */
	mixin Border;
	mixin Height;
	mixin Padding;
	mixin Relief;
	mixin Width;
}
