/**
 * Widget module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.scrollbar;

/**
 * Imports.
 */
import std.conv;
import tkd.element.uielement;
import tkd.widget.common.xscrollcommand;
import tkd.widget.common.yscrollcommand;
import tkd.widget.widget;

/**
 * Scrollbar widgets are typically linked to an associated window that displays 
 * a document of some sort, such as a file being edited or a drawing. A 
 * scrollbar displays a thumb in the middle portion of the scrollbar, whose 
 * position and size provides information about the portion of the document 
 * visible in the associated window. The thumb may be dragged by the user to 
 * control the visible region. Depending on the theme, two or more arrow 
 * buttons may also be present; these are used to scroll the visible region in 
 * discrete units.
 *
 * Additional_Events:
 *     Additional events that can also be bound to using the $(LINK2 ../element/uielement.html#UiElement.bind, bind) method.
 *     $(P
 *         &lt;&lt;PrevWindow&gt;&gt;,
 *         &lt;Alt-Key&gt;,
 *         &lt;B1-Motion&gt;,
 *         &lt;B2-Motion&gt;,
 *         &lt;Button-1&gt;,
 *         &lt;Button-2&gt;,
 *         &lt;ButtonRelease-1&gt;,
 *         &lt;ButtonRelease-2&gt;,
 *         &lt;Key-F10&gt;,
 *         &lt;Key-Tab&gt;,
 *     )
 *
 * States:
 *     The scrollbar automatically sets the disabled state when the entire 
 *     range is visible and clears it otherwise.
 *
 * See_Also:
 *     $(LINK2 ./widget.html, tkd.widget.widget)
 */
abstract class ScrollBar : Widget
{
	/**
	 * Construct the widget.
	 *
	 * Params:
	 *     parent = The parent of this widget.
	 *
	 * See_Also:
	 *     $(LINK2 ../element/uielement.html, tkd.element.uielement) $(BR)
	 */
	this(UiElement parent = null)
	{
		super(parent);
		this._elementId = "scrollbar";

		this._tk.eval("ttk::scrollbar %s", this.id);
	}

	/**
	 * Returns a real number indicating the fractional change in the scrollbar 
	 * setting that corresponds to a given change in thumb position. For 
	 * example, if the scrollbar is horizontal, the result indicates how much 
	 * the scrollbar setting must change to move the thumb deltaX pixels to the 
	 * right (deltaY is ignored in this case). If the scrollbar is vertical, 
	 * the result indicates how much the scrollbar setting must change to move 
	 * the thumb deltaY pixels down. The arguments and the result may be zero 
	 * or negative.
	 *
	 * Params:
	 *     deltaX = The amount to move horizontally.
	 *     deltaY = The amount to move vertically.
	 *
	 * Returns:
	 *     The fractional change.
	 */
	public double getDelta(int deltaX, int deltaY)
	{
		this._tk.eval("%s delta %s %s", this.id, deltaX, deltaY);
		return this._tk.getResult!(double);
	}

	/**
	 * Returns a real number between 0 and 1 indicating where the point given 
	 * by x and y lies in the trough area of the scrollbar, where 0.0 
	 * corresponds to the top or left of the trough and 1.0 corresponds to the 
	 * bottom or right. X and y are pixel coordinates relative to the scrollbar 
	 * widget. If x and y refer to a point outside the trough, the closest 
	 * point in the trough is used.
	 *
	 * Params:
	 *     x = The x position.
	 *     y = The y position.
	 *
	 * Returns:
	 *     The fractional position.
	 */
	public double getFraction(int x, int y)
	{
		this._tk.eval("%s fraction %s %s", this.id, x, y);
		return this._tk.getResult!(double);
	}
}

/**
 * Class representing a horizontal scrollbar widget.
 */
class XScrollBar : ScrollBar
{
	/**
	 * Construct the widget.
	 *
	 * Params:
	 *     parent = The parent of this widget.
	 *
	 * See_Also:
	 *     $(LINK2 ../element/uielement.html, tkd.element.uielement) $(BR)
	 */
	this(UiElement parent = null)
	{
		super(parent);
		this._tk.eval("%s configure -orient horizontal", this.id);
	}

	/**
	 * Attach a horizontally scrollable widget to this scrollbar.
	 *
	 * Params:
	 *     scrollableWidget = A horizontally scrollable widget.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 *
	 * See_Also:
	 *     $(LINK2 ./common/xscrollcommand.html, tkd.widget.common.xscrollcommand) $(BR)
	 */
	public auto attachWidget(this T, S)(IXScrollable!(S) scrollableWidget)
	{
		auto widget = cast(Widget)scrollableWidget;

		this._tk.eval("%s configure -command [list %s xview]", this.id, widget.id);

		return cast(T) this;
	}

}

/**
 * Class representing a vertical scrollbar widget.
 */
class YScrollBar : ScrollBar
{
	/**
	 * Construct the widget.
	 *
	 * Params:
	 *     parent = The parent of this widget.
	 *
	 * See_Also:
	 *     $(LINK2 ../element/uielement.html, tkd.element.uielement) $(BR)
	 */
	this(UiElement parent = null)
	{
		super(parent);
		this._tk.eval("%s configure -orient vertical", this.id);
	}

	/**
	 * Attach a vertically scrollable widget to this scrollbar.
	 *
	 * Params:
	 *     scrollableWidget = A vertically scrollable widget.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 *
	 * See_Also:
	 *     $(LINK2 ./common/yscrollcommand.html, tkd.widget.common.yscrollcommand) $(BR)
	 */
	public auto attachWidget(this T, S)(IYScrollable!(S) scrollableWidget)
	{
		auto widget = cast(Widget)scrollableWidget;

		this._tk.eval("%s configure -command [list %s yview]", this.id, widget.id);

		return cast(T) this;
	}
}
