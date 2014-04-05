/**
 * State module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.common.canvas.state;

/**
 * These are common commands that apply to all widgets that have them injected.
 */
mixin template State()
{
	/**
	 * The state of the item.
	 */
	private string _state;

	/**
	 * Get the state of this item.
	 *
	 * Returns:
	 *     The state of this item.
	 */
	public string getState()
	{
		if (this._parent)
		{
			this._tk.eval("%s itemcget %s -state", this._parent.id, this.id);
			this._state = this._tk.getResult!(string);
		}

		return this._state;
	}

	/**
	 * Set the item state. The only valid states are normal, disabled or 
	 * hidden.
	 *
	 * Params:
	 *    state = The state to set.
	 *
	 * Returns:
	 *     This item to aid method chaining.
	 *
	 * See_Also:
	 *     $(LINK2 ./state.html, tkd.widget.state) $(BR)
	 */
	public auto setState(this T)(string state)
	{
		this._state = state;

		if (this._parent && this._state.length)
		{
			this._tk.eval("%s itemconfigure %s -state {%s}", this._parent.id, this.id, this._state);
		}

		return cast(T) this;
	}
}
