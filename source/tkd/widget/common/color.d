/**
 * Color module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.common.color;

/**
 * These are common commands that apply to all widgets that have them injected.
 */
mixin template Color()
{
	public auto setForegroundColor(this T)(string color)
	{
		this._tk.eval("%s configure -foreground %s", this.id, color);

		return cast(T) this;
	}

    public auto setBackgroundColor(this T)(string color)
	{
		this._tk.eval("%s configure -background %s", this.id, color);

		return cast(T) this;
	}
}
