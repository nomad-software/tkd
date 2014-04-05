/**
 * Widget specific module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.common.canvas.widgetspecific;

/**
 * These are common commands that apply to all widgets that have them injected.
 */
mixin template WidgetSpecific()
{
	/**
	 * The widget to use.
	 */
	private Widget _widget;

	/**
	 * The widget width.
	 */
	private int _width;

	/**
	 * The widget height.
	 */
	private int _height;

	/**
	 * Get the widget.
	 *
	 * Returns:
	 *     The widget.
	 */
	public Widget getWidget()
	{
		return this._widget;
	}

	/**
	 * Specifies the widget to associate with this item. The widget specified 
	 * must either be a child of the canvas widget or a child of some ancestor 
	 * of the canvas widget.
	 *
	 * Params:
	 *    widget = The widget.
	 *
	 * Returns:
	 *     This item to aid method chaining.
	 */
	public auto setWidget(this T)(Widget widget)
	{
		this._widget = widget;

		if (this._parent && this._widget)
		{
			this._tk.eval("%s itemconfigure %s -window %s", this._parent.id, this.id, this._widget.id);
		}

		return cast(T) this;
	}

	/**
	 * Get the widget width.
	 *
	 * Returns:
	 *     The widget width.
	 */
	public int getWidth()
	{
		if (this._parent)
		{
			this._tk.eval("%s itemcget %s -width", this._parent.id, this.id);
			this._width = this._tk.getResult!(int);
		}

		return this._width;
	}

	/**
	 * Specifies the width to assign to the item's widget. If this option is 
	 * not specified, or if it is specified as zero, then the widget is given 
	 * whatever width it requests internally.
	 *
	 * Params:
	 *    width = The widget width.
	 *
	 * Returns:
	 *     This item to aid method chaining.
	 */
	public auto setWidth(this T)(int width)
	{
		this._width = width;

		if (this._parent)
		{
			this._tk.eval("%s itemconfigure %s -width %s", this._parent.id, this.id, this._width);
		}

		return cast(T) this;
	}

	/**
	 * Get the widget height.
	 *
	 * Returns:
	 *     The widget height.
	 */
	public int getHeight()
	{
		if (this._parent)
		{
			this._tk.eval("%s itemcget %s -height", this._parent.id, this.id);
			this._height = this._tk.getResult!(int);
		}

		return this._height;
	}

	/**
	 * Specifies the height to assign to the item's widget. If this option is 
	 * not specified, or if it is specified as zero, then the widget is given 
	 * whatever height it requests internally.
	 *
	 * Params:
	 *    height = The widget height.
	 *
	 * Returns:
	 *     This item to aid method chaining.
	 */
	public auto setHeight(this T)(int height)
	{
		this._height = height;

		if (this._parent)
		{
			this._tk.eval("%s itemconfigure %s -height %s", this._parent.id, this.id, this._height);
		}

		return cast(T) this;
	}
}
