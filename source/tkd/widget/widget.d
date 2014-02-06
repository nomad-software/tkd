/**
 * Widget module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.widget;

/**
 * Imports.
 */
import std.algorithm;
import std.array;
import std.string;
import tkd.element.uielement;
import tkd.widget.state;

/**
 * The widget base class.
 */
abstract class Widget : UiElement
{
	/**
	 * Construct the widget.
	 *
	 * Params:
	 *     parent = An optional parent of this widget.
	 */
	public this(UiElement parent = null)
	{
		super(parent);

		this._elementId = "widget";
	}

	/**
	 * Set the widget's state.
	 *
	 * Params:
	 *     state = An array of valid widget states.
	 *
	 * See_Also:
	 *     $(LINK2 state.html, tkd.widget.state) for supported states.
	 */
	public void setState(string[] state)
	{
		this._tk.eval("%s state { %s }", this.id, state.join(" "));
	}

	/**
	 * Get the widget's state.
	 *
	 * Returns:
	 *     An array of valid widget states.
	 *
	 * See_Also:
	 *     $(LINK2 state.html, tkd.widget.state) for supported states.
	 */
	public string[] getState()
	{
		this._tk.eval("%s state", this.id);
		return this._tk.getResult().split();
	}

	/**
	 * Test if a widget is in a particular state.
	 *
	 * Params:
	 *     state = An array of valid widget states.
	 *
	 * Returns:
	 *     true is the widget is in that state, false if not.
	 *
	 * See_Also:
	 *     $(LINK2 state.html, tkd.widget.state) for supported states.
	 */
	public bool inState(string[] state)
	{
		if (state.canFind(State.normal))
		{
			throw new Exception("State.normal is not supported by inState method.");
		}

		this._tk.eval("%s instate { %s }", this.id, state.join(" "));
		return this._tk.getResult() == "1";
	}

	/**
	 * Remove the widget's state.
	 *
	 * Params:
	 *     state = An array of valid widget states.
	 *
	 * See_Also:
	 *     $(LINK2 state.html, tkd.widget.state) for supported states.
	 */
	public void removeState(string[] state)
	{
		this._tk.eval("%s state { !%s }", this.id, state.join(" !"));
	}

	/**
	 * Reset the widget's state to default.
	 *
	 * See_Also:
	 *     $(LINK2 state.html, tkd.widget.state) for supported states.
	 */
	public void resetState()
	{
		this.removeState(this.getState());
	}

	/**
	 * Set the widget's style.
	 *
	 * Params:
	 *     style = A valid widget style.
	 *
	 * See_Also:
	 *     $(LINK2 style.html, tkd.widget.style) for supported styles.
	 */
	public void setStyle(string style)
	{
		this._tk.eval("%s configure -style %s", this.id, style);
	}

	/**
	 * Get the widget's style.
	 *
	 * Returns:
	 *     The widget's style.
	 *
	 * See_Also:
	 *     $(LINK2 style.html, tkd.widget.style) for supported styles.
	 */
	public string getStyle()
	{
		this._tk.eval("%s cget -style", this.id);
		if (this._tk.getResult().empty())
		{
			return this.getClass();
		}
		return this._tk.getResult();
	}

	/**
	 * Set if the widget can recieve focus during keyboard traversal.
	 *
	 * Params:
	 *     focus = A valid focus setting.
	 *
	 * See_Also:
	 *     $(LINK2 focus.html, tkd.widget.focus) for supported focus states.
	 */
	public void setFocus(string focus)
	{
		this._tk.eval("%s configure -takefocus %s", this.id, focus);
	}

	/**
	 * Get if the widget can recieve focus during keyboard traversal.
	 *
	 * Returns:
	 *     The widget's focus setting.
	 *
	 * See_Also:
	 *     $(LINK2 focus.html, tkd.widget.focus) for supported focus states.
	 */
	public string getFocus()
	{
		this._tk.eval("%s cget -takefocus", this.id);
		return this._tk.getResult();
	}

	/**
	 * Geometry method for placing the widget onto the interface.
	 */
	public void pack()
	{
		string tkScript = format("pack %s -padx 10 -pady 10", this.id);
		this._tk.eval(tkScript);
	}
}
