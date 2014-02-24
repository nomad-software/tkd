/**
 * Anchor module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.common.anchor;

/**
 * These are common commands that apply to all widgets that have them injected.
 */
mixin template Anchor()
{
	/**
	 * Specifies how the information in the widget is positioned relative to the inner margins.
	 *
	 * Params:
	 *     position = The position of the anchor.
	 *
	 * See_Also:
	 *     $(LINK2 ../anchorposition.html, tkd.widget.anchorposition) $(BR)
	 */
	public void setAnchor(string position)
	{
		this._tk.eval("%s configure -anchor %s", this.id, position);
	}
}
