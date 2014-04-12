/**
 * Bind module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.common.canvas.bind;

/**
 * These are common commands that apply to all widgets that have them injected.
 */
mixin template Bind()
{
	/**
	 * The bindings.
	 */
	private CommandCallback[string] _bindings;

	/**
	 * Bind a callback to a particular event triggered by this item.
	 * This command is identical to $(LINK2 
	 * ../../../element/uielement.html#UiElement, UiElement)'s bind method.
	 *
	 * If bindings have been created for a canvas widget they are invoked in 
	 * addition to bindings created for the canvas's items. The bindings for 
	 * items will be invoked before any of the bindings for the window as a 
	 * whole.
	 *
	 * Params:
	 *     binding = The binding that triggers this event. See below.
	 *     callback = The delegate callback to execute when the event triggers.
	 *
	 * Returns:
	 *     This item to aid method chaining.
	 *
	 * Bindings:
	 *     The only events for which bindings may be specified are those 
	 *     related to the mouse and keyboard (such as Enter, Leave, 
	 *     ButtonPress, Motion, and KeyPress) or virtual events.
	 *
	 * See_Also:
	 *     $(LINK2 ../../../element/element.html#CommandCallback, tkd.element.element.CommandCallback) $(BR)
	 *     $(LINK2 ../../../element/uielement.html#UiElement, tkd.element.uielement.UiElement) $(BR)
	 */
	public auto bind(this T)(string binding, CommandCallback callback)
	{
		assert(!std.regex.match(binding, r"^<.*?>$").empty, "Binding must take the form of <binding>");

		this._bindings[binding] = callback;

		if (this._parent)
		{
			string command = this.createCommand(callback, binding);
			this._tk.eval("%s bind %s {%s} {%s %%b %%k %%x %%y %%D %%K %%X %%Y}", this._parent.id, this.id, binding, command);
		}

		return cast(T) this;
	}

	/**
	 * Unbind a previous event binding.
	 *
	 * Params:
	 *     binding = The binding to remove.
	 *
	 * Returns:
	 *     This item to aid method chaining.
	 */
	public auto unbind(this T)(string binding)
	{
		this._bindings.remove(binding);

		if (this._parent)
		{
			this._tk.deleteCommand(this.getCommandName(binding));
			this._tk.eval("%s bind %s {%s} {}", this._parent.id, this.id, binding);
		}

		return cast(T) this;
	}
}
