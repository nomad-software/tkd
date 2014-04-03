/**
 * Anchor module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.common.canvas.anchor;

/**
 * These are common commands that apply to all widgets that have them injected.
 */
mixin template Anchor()
{
	/**
	 * The anchor position.
	 */
	private string _anchor;

	/**
	 * Get the anchor.
	 *
	 * Returns:
	 *     The anchor of the item.
	 */
	public string getAnchor()
	{
		return this._anchor;
	}

	/**
	 * Set the anchor position.
	 *
	 * Params:
	 *    anchor = The anchor position of the text.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 *
	 * See_Also:
	 *     $(LINK2 ./anchorposition.html, tkd.widget.anchorposition) $(BR)
	 */
	public auto setAnchor(this T)(string anchor)
	{
		this._anchor = anchor;

		if (this._parent && this._anchor.length)
		{
			this._tk.eval("%s itemconfigure %s -anchor {%s}", this._parent.id, this.id, this._anchor);
		}

		return cast(T) this;
	}
}
