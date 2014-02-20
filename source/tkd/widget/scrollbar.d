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
import tkd.element.uielement;
import tkd.widget.common.xscrollcommand;
import tkd.widget.common.yscrollcommand;
import tkd.widget.widget;

/**
 * Class representing a horizontal scrollbar widget.
 *
 * See_Also:
 *     $(LINK2 ./widget.html, tkd.widget.widget)
 */
class XScrollbar : Widget
{
	/**
	 * Construct the widget.
	 *
	 * Params:
	 *     parent = The parent of this widget.
	 *
	 * See_Also:
	 *     $(LINK2 ../element/uielement.html, tkd.element.UiElement) $(BR)
	 */
	this(UiElement parent = null)
	{
		super(parent);
		this._elementId = "xscrollbar";

		this._tk.eval("ttk::scrollbar %s -orient horizontal", this.id);
	}

	/**
	 * Attach a horizontally scrollable widget to this scrollbar.
	 *
	 * Params:
	 *     scrollableWidget = A horizontally scrollable widget.
	 */
	public void attachWidget(IXScrollable scrollableWidget)
	{
		auto widget = cast(Widget)scrollableWidget;

		this._tk.eval("%s configure -command [list %s xview]", this.id, widget.id);
	}
}

/**
 * Class representing a vertical scrollbar widget.
 *
 * See_Also:
 *     $(LINK2 ./widget.html, tkd.widget.widget)
 */
class YScrollbar : Widget
{
	/**
	 * Construct the widget.
	 *
	 * Params:
	 *     parent = The parent of this widget.
	 *
	 * See_Also:
	 *     $(LINK2 ../element/uielement.html, tkd.element.UiElement) $(BR)
	 */
	this(UiElement parent = null)
	{
		super(parent);
		this._elementId = "yscrollbar";

		this._tk.eval("ttk::scrollbar %s -orient vertical", this.id);
	}

	/**
	 * Attach a vertically scrollable widget to this scrollbar.
	 *
	 * Params:
	 *     scrollableWidget = A vertically scrollable widget.
	 */
	public void attachWidget(IYScrollable scrollableWidget)
	{
		auto widget = cast(Widget)scrollableWidget;

		this._tk.eval("%s configure -command [list %s yview]", this.id, widget.id);
	}
}
