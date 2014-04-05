/**
 * Outline dash module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.common.canvas.outlinedash;

/**
 * These are common commands that apply to all widgets that have them injected.
 */
mixin template OutlineDash()
{
	import std.algorithm;
	import std.array;
	import std.conv;

	/**
	 * The dash pattern.
	 */
	private int[] _outlineDash;

	/**
	 * The active dash pattern.
	 */
	private int[] _activeOutlineDash;

	/**
	 * The disabled dash pattern.
	 */
	private int[] _disabledOutlineDash;

	/**
	 * The dash offset.
	 */
	private int _outlineDashOffset;

	/**
	 * Get the dash pattern.
	 *
	 * Returns:
	 *     The dash pattern of the item.
	 */
	public int[] getOutlineDash()
	{
		if (this._parent)
		{
			this._tk.eval("%s itemcget %s -dash", this._parent.id, this.id);
			this._outlineDash = this._tk.getResult!(string).split().map!(to!(int)).array;
		}

		return this._outlineDash;
	}

	/**
	 * Set the dash pattern of the outline. Each element represents the number 
	 * of pixels of a line segment. Only the odd segments are drawn using the 
	 * outline color. The other segments are drawn transparent.
	 *
	 * Params:
	 *    dash = The dash pattern.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto setOutlineDash(this T)(int[] dash)
	{
		this._outlineDash = dash;

		if (this._parent && this._outlineDash.length)
		{
			this._tk.eval("%s itemconfigure %s -dash [list %s]", this._parent.id, this.id, this._outlineDash.map!(to!(string)).join(" "));
		}

		return cast(T) this;
	}

	/**
	 * Get the active dash pattern.
	 * An item's active state is triggered when the mouse rolls over the item.
	 *
	 * Returns:
	 *     The active dash pattern of the item.
	 */
	public int[] getActiveOutlineDash()
	{
		if (this._parent)
		{
			this._tk.eval("%s itemcget %s -activedash", this._parent.id, this.id);
			this._activeOutlineDash = this._tk.getResult!(string).split().map!(to!(int)).array;
		}

		return this._activeOutlineDash;
	}

	/**
	 * Set the active dash pattern of the outline. Each element represents the 
	 * number of pixels of a line segment. Only the odd segments are drawn 
	 * using the outline color. The other segments are drawn transparent. An 
	 * item's active state is triggered when the mouse rolls over the item.
	 *
	 * Params:
	 *    dash = The active dash pattern.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto setActiveOutlineDash(this T)(int[] dash)
	{
		this._activeOutlineDash = dash;

		if (this._parent && this._activeOutlineDash.length)
		{
			this._tk.eval("%s itemconfigure %s -activedash [list %s]", this._parent.id, this.id, this._activeOutlineDash.map!(to!(string)).join(" "));
		}

		return cast(T) this;
	}

	/**
	 * Get the disabled dash pattern.
	 *
	 * Returns:
	 *     The disabled dash pattern of the item.
	 */
	public int[] getDisabledOutlineDash()
	{
		if (this._parent)
		{
			this._tk.eval("%s itemcget %s -disableddash", this._parent.id, this.id);
			this._disabledOutlineDash = this._tk.getResult!(string).split().map!(to!(int)).array;
		}

		return this._disabledOutlineDash;
	}

	/**
	 * Set the disabled dash pattern of the outline. Each element represents the 
	 * number of pixels of a line segment. Only the odd segments are drawn 
	 * using the outline color. The other segments are drawn transparent.
	 *
	 * Params:
	 *    dash = The disabled dash pattern.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto setDisabledOutlineDash(this T)(int[] dash)
	{
		this._disabledOutlineDash = dash;

		if (this._parent && this._disabledOutlineDash.length)
		{
			this._tk.eval("%s itemconfigure %s -disableddash [list %s]", this._parent.id, this.id, this._disabledOutlineDash.map!(to!(string)).join(" "));
		}

		return cast(T) this;
	}

	/**
	 * Get the dash offset.
	 *
	 * Returns:
	 *     The dash offset.
	 */
	public int getOutlineDashOffset()
	{
		if (this._parent)
		{
			this._tk.eval("%s itemcget %s -dashoffset", this._parent.id, this.id);
			this._outlineDashOffset = this._tk.getResult!(int);
		}

		return this._outlineDashOffset;
	}

	/**
	 * Set the dash offset.
	 *
	 * Params:
	 *    offset = The dash offset.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto setOutlineDashOffset(this T)(int offset)
	{
		this._outlineDashOffset = offset;

		if (this._parent && this._outlineDashOffset > 0)
		{
			this._tk.eval("%s itemconfigure %s -dashoffset %s", this._parent.id, this.id, this._outlineDashOffset);
		}

		return cast(T) this;
	}
}
