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
	 */
	public void invokeCommand()
	{
		this._tk.eval("%s invoke", this.id);
	}
}
