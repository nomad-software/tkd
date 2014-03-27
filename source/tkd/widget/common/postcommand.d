/**
 * Post command module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.common.postcommand;

/**
 * These are common commands that apply to all widgets that have them injected.
 */
mixin template PostCommand()
{
	import std.string;
	import tkd.element.element;

	/**
	 * Add a post command to a widget. This is usually to modify the widget after creation.
	 *
	 * Params:
	 *     callback = The delegate callback to execute when invoking the post command.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 *
	 * See_Also:
	 *     $(LINK2 ../../element/element.html#CommandCallback, tkd.element.element.CommandCallback)
	 */
	public auto setPostCommand(this T)(CommandCallback callback)
	{
		string command = this.createCommand(callback, "postcommand");
		this._tk.eval("%s configure -postcommand %s", this.id, command);

		return cast(T) this;
	}

	/**
	 * Remove a previously set post command.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto removePostCommand(this T)()
	{
		this._tk.deleteCommand(this.getCommandName("postcommand"));
		this._tk.eval("%s configure -postcommand {}", this.id);

		return cast(T) this;
	}
}
