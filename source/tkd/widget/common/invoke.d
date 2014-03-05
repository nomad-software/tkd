/**
 * Invoke module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.common.invoke;

/**
 * These are common commands that apply to all widgets that have them injected.
 */
mixin template Invoke()
{
	/**
	 * Invoke the command associated with the widget.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto invokeCommand()
	{
		this._tk.eval("%s invoke", this.id);
		return this;
	}
}
