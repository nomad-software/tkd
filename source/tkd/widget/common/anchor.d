/**
 * Anchor module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.common.anchor;

/**
 * These are common commands that apply to all widgets that have them injected.
 *
 * Params:
 *     anchorCommand = The widget command that handles the anchor.
 */
mixin template Anchor(string anchorCommand = "-anchor")
{
	/**
	 * Specifies how text in the widget is positioned relative to the inner margins.
	 *
	 * Params:
	 *     position = The position of the anchor.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 *
	 * See_Also:
	 *     $(LINK2 ../anchorposition.html, tkd.widget.anchorposition) $(BR)
	 */
	public auto setTextAnchor(string position)
	{
		this._tk.eval("%s configure " ~ anchorCommand ~ " %s", this.id, position);
		return this;
	}
}
