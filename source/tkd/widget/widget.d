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
import tkd.element.element;
import tkd.element.uielement;
import tkd.widget.state;

/**
 * The widget base class.
 *
 * See_Also:
 *     $(LINK2 ../element/uielement.html, tkd.element.uielement)
 */
abstract class Widget : UiElement
{
	/**
	 * Construct the widget.
	 *
	 * Params:
	 *     parent = An optional parent of this widget.
	 *
	 * See_Also:
	 *     $(LINK2 ../element/uielement.html, tkd.element.uielement)
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
	 *     state = An array of widget states.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 *
	 * See_Also:
	 *     $(LINK2 ./state.html, tkd.widget.state) for states.
	 */
	public auto setState(this T)(string[] state)
	{
		this._tk.eval("%s state { %s }", this.id, state.join(" "));

		return cast(T) this;
	}

	/**
	 * Get the widget's state.
	 *
	 * Returns:
	 *     An array of widget states.
	 *
	 * See_Also:
	 *     $(LINK2 ./state.html, tkd.widget.state) for returned states.
	 */
	public string[] getState()
	{
		this._tk.eval("%s state", this.id);
		return this._tk.getResult!(string).split();
	}

	/**
	 * Test if a widget is in a particular state.
	 *
	 * Params:
	 *     state = An array of widget states.
	 *
	 * Returns:
	 *     true is the widget is in that state, false if not.
	 *
	 * See_Also:
	 *     $(LINK2 ./state.html, tkd.widget.state) for states.
	 */
	public bool inState(string[] state)
	{
		if (state.canFind(State.normal))
		{
			throw new Exception("State.normal is not supported by inState method.");
		}

		this._tk.eval("%s instate { %s }", this.id, state.join(" "));
		return this._tk.getResult!(int) == 1;
	}

	/**
	 * Remove the widget's state.
	 *
	 * Params:
	 *     state = An array of widget states.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 *
	 * See_Also:
	 *     $(LINK2 ./state.html, tkd.widget.state) for states.
	 */
	public auto removeState(this T)(string[] state)
	{
		this._tk.eval("%s state { !%s }", this.id, state.join(" !"));

		return cast(T) this;
	}

	/**
	 * Reset the widget's state to default.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 *
	 * See_Also:
	 *     $(LINK2 ./state.html, tkd.widget.state) for widget states.
	 */
	public auto resetState(this T)()
	{
		this.removeState(this.getState());

		return cast(T) this;
	}

	/**
	 * Set the widget's style.
	 *
	 * Params:
	 *     style = A widget style.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 *
	 * See_Also:
	 *     $(LINK2 ./style.html, tkd.widget.style) for styles.
	 */
	public auto setStyle(this T)(string style)
	{
		this._tk.eval("%s configure -style %s", this.id, style);

		return cast(T) this;
	}

	/**
	 * Get the widget's style.
	 *
	 * Returns:
	 *     The widget's style.
	 *
	 * See_Also:
	 *     $(LINK2 ./style.html, tkd.widget.style) for returned styles.
	 */
	public string getStyle()
	{
		this._tk.eval("%s cget -style", this.id);
		if (this._tk.getResult!(string).empty())
		{
			return this.getClass();
		}
		return this._tk.getResult!(string);
	}

	/**
	 * Set if the widget can recieve focus during keyboard traversal.
	 *
	 * Params:
	 *     focus = A focus setting.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 *
	 * See_Also:
	 *     $(LINK2 ./focus.html, tkd.widget.focus) for focus states.
	 */
	public auto setFocus(this T)(string focus)
	{
		this._tk.eval("%s configure -takefocus %s", this.id, focus);

		return cast(T) this;
	}

	/**
	 * Get if the widget can recieve focus during keyboard traversal.
	 *
	 * Returns:
	 *     The widget's focus setting.
	 *
	 * See_Also:
	 *     $(LINK2 ./focus.html, tkd.widget.focus) for returned focus states.
	 */
	public string getFocus()
	{
		this._tk.eval("%s cget -takefocus", this.id);
		return this._tk.getResult!(string);
	}

	/**
	 * Geometry method for placing the widget onto the uielement.
	 */
	public auto pack(this T)()
	{
		string tkScript = format("pack %s -padx 10 -pady 10", this.id);
		this._tk.eval(tkScript);

		return cast(T) this;
	}
}
