/**
 * Outline width module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.common.canvas.outlinewidth;

/**
 * These are common commands that apply to all widgets that have them injected.
 */
mixin template OutlineWidth()
{
	import std.typecons : Nullable;

	/**
	 * The width of the outline.
	 */
	private Nullable!(int) _outlineWidth;

	/**
	 * The active width of the outline.
	 */
	private Nullable!(int) _activeOutlineWidth;

	/**
	 * The disabled width of the outline.
	 */
	private Nullable!(int) _disabledOutlineWidth;

	/**
	 * Get the width of the outline.
	 *
	 * Returns:
	 *     The width of the outline;
	 */
	public int getOutlineWidth()
	{
		if (this._parent)
		{
			this._tk.eval("%s itemcget %s -width", this._parent.id, this.id);
			this._outlineWidth = this._tk.getResult!(int);
		}

		return this._outlineWidth.isNull ? 0 : this._outlineWidth.get;
	}

	/**
	 * Set the width of the outline.
	 *
	 * Params:
	 *    width = The width of the outline.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto setOutlineWidth(this T, W)(W width) if (is(W == int) || is(W == Nullable!(int)))
	{
		static if (is(W == Nullable!(int)))
		{
			if (width.isNull)
			{
				return cast(T) this;
			}
		}

		this._outlineWidth = width;

		if (this._parent)
		{
			this._tk.eval("%s itemconfigure %s -width %s", this._parent.id, this.id, this._outlineWidth);
		}

		return cast(T) this;
	}

	/**
	 * Get the width of the active outline.
	 * An item's active state is triggered when the mouse rolls over the item.
	 *
	 * Returns:
	 *     The width of the active outline;
	 */
	public int getActiveOutlineWidth()
	{
		if (this._parent)
		{
			this._tk.eval("%s itemcget %s -activewidth", this._parent.id, this.id);
			this._activeOutlineWidth = this._tk.getResult!(int);
		}

		return this._activeOutlineWidth.isNull ? 0 : this._activeOutlineWidth.get;
	}

	/**
	 * Set the width of the active outline.
	 * An item's active state is triggered when the mouse rolls over the item.
	 *
	 * Params:
	 *    width = The width of the active outline.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto setActiveOutlineWidth(this T, W)(W width) if (is(W == int) || is(W == Nullable!(int)))
	{
		static if (is(W == Nullable!(int)))
		{
			if (width.isNull)
			{
				return cast(T) this;
			}
		}

		this._activeOutlineWidth = width;

		if (this._parent)
		{
			this._tk.eval("%s itemconfigure %s -activewidth %s", this._parent.id, this.id, this._activeOutlineWidth);
		}

		return cast(T) this;
	}

	/**
	 * Get the width of the disabled outline.
	 *
	 * Returns:
	 *     The width of the disabled outline;
	 */
	public int getDisabledOutlineWidth()
	{
		if (this._parent)
		{
			this._tk.eval("%s itemcget %s -disabledwidth", this._parent.id, this.id);
			this._disabledOutlineWidth = this._tk.getResult!(int);
		}

		return this._disabledOutlineWidth.isNull ? 0 : this._disabledOutlineWidth.get;
	}

	/**
	 * Set the width of the disabled outline.
	 *
	 * Params:
	 *    width = The width of the disabled outline.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 *
	 * Bugs:
	 *     This doesn't seem to have any effect in Tcl/Tk v8.6.1. It ignores 
	 *     this setting and applies a 1 pixel width.
	 */
	public auto setDisabledOutlineWidth(this T, W)(W width) if (is(W == int) || is(W == Nullable!(int)))
	{
		static if (is(W == Nullable!(int)))
		{
			if (width.isNull)
			{
				return cast(T) this;
			}
		}

		this._disabledOutlineWidth = width;

		if (this._parent)
		{
			this._tk.eval("%s itemconfigure %s -disabledwidth %s", this._parent.id, this.id, this._disabledOutlineWidth);
		}

		return cast(T) this;
	}
}
