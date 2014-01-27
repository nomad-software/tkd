/**
 * Widget module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.element.widget.widget;

/**
 * Imports.
 */
import std.algorithm;
import std.array;
import std.string;
import tkd.element.element;
import tkd.element.widget.state;

/**
 * The widget base class.
 */
abstract class Widget : Element
{
	/**
	 * Construct the widget.
	 *
	 * Params:
	 *     parent = An optional parent of this widget.
	 */
	public this(Element parent = null)
	{
		super(parent);

		this._elementId = "widget";
	}

	/**
	 * Set the widget's state.
	 *
	 * Params:
	 *     state = An array of valid widget states.
	 */
	public void setState(string[] state)
	{
		this._tk.eval(format("%s state { %s }", this.id, state.join(" ")));
	}

	/**
	 * Get the widget's state.
	 *
	 * Returns:
	 *     An array of valid widget states.
	 */
	public string[] getState()
	{
		this._tk.eval(format("%s state", this.id));
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
	 */
	public bool inState(string[] state)
	{
		if (state.canFind(State.normal))
		{
			throw new Exception("State.normal is not supported by inState method.");
		}

		this._tk.eval(format("%s instate { %s }", this.id, state.join(" ")));
		return this._tk.getResult() == "1";
	}

	/**
	 * Remove the widget's state.
	 *
	 * Params:
	 *     state = An array of valid widget states.
	 */
	public void removeState(string[] state)
	{
		this._tk.eval(format("%s state { !%s }", this.id, state.join(" !")));
	}

	/**
	 * Reset the widget's state to default.
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
	 */
	public void setStyle(string style)
	{
		this._tk.eval(format("%s configure -style %s", this.id, style));
	}

	/**
	 * Get the widget's style.
	 *
	 * Returns:
	 *     The widget's style.
	 */
	public string getStyle()
	{
		this._tk.eval(format("%s cget -style", this.id));
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
	 *     style = A valid focus setting.
	 */
	public void setFocus(string focus)
	{
		this._tk.eval(format("%s configure -takefocus %s", this.id, focus));
	}

	/**
	 * Get if the widget can recieve focus during keyboard traversal.
	 *
	 * Returns:
	 *     The widget's focus setting.
	 */
	public string getFocus()
	{
		this._tk.eval(format("%s cget -takefocus", this.id));
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
