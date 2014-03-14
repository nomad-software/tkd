/**
 * Widget module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.progressbar;

/**
 * Imports.
 */
import std.string;
import tkd.element.uielement;
import tkd.widget.common.length;
import tkd.widget.common.value;
import tkd.widget.orientation;
import tkd.widget.widget;

/**
 * A progress bar widget shows the status of a long-running operation. They can 
 * operate in two modes: determinate mode shows the amount completed relative 
 * to the total amount of work to be done, and indeterminate mode provides an 
 * animated display to let the user know that something is happening.
 *
 * Common_Commands:
 *     These are injected common commands that can also be used with this widget.
 *     $(P
 *         $(LINK2 ./common/length.html, Length) $(BR)
 *         $(LINK2 ./common/value.html, Value) $(BR)
 *     )
 *
 * Additional_Events:
 *     Additional events that can also be bound to using the $(LINK2 ../element/uielement.html#UiElement.bind, bind) method.
 *     $(P
 *         &lt;&lt;PrevWindow&gt;&gt;,
 *         &lt;Alt-Key&gt;,
 *         &lt;Key-F10&gt;,
 *         &lt;Key-Tab&gt;,
 *     )
 *
 * See_Also:
 *     $(LINK2 ./widget.html, tkd.widget.widget)
 */
class ProgressBar : Widget
{
	/**
	 * The name of the variable that contains the widget's value.
	 */
	private string _valueVariable;

	/**
	 * Construct the widget.
	 *
	 * Params:
	 *     parent = The parent of this widget.
	 *     orientation = The orientation of the widget.
	 *
	 * See_Also:
	 *     $(LINK2 ../element/uielement.html, tkd.element.UiElement) $(BR)
	 *     $(LINK2 ./orientation.html, tkd.widget.orientation) for orientations.
	 */
	public this(UiElement parent, string orientation = Orientation.horizontal)
	{
		super(parent);
		this._elementId     = "progressbar";
		this._valueVariable = format("variable-%s", this.generateHash(this.id));

		this._tk.eval("ttk::progressbar %s -orient %s -variable %s", this.id, orientation, this._valueVariable);
	}

	/**
	 * Construct the widget.
	 *
	 * Params:
	 *     orientation = The orientation of the widget.
	 *
	 * See_Also:
	 *     $(LINK2 ./orientation.html, tkd.widget.orientation) for orientations.
	 */
	public this(string orientation = Orientation.horizontal)
	{
		this(null, orientation);
	}

	/**
	 * Set the mode of the progress bar.
	 *
	 * Params:
	 *     mode = The mode of the progress bar.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 *
	 * See_Also:
	 *     $(LINK2 ./progressbarmode.html, tkd.widget.progressbarmode) for modes.
	 */
	public auto setMode(this T)(string mode)
	{
		this._tk.eval("%s configure -mode %s", this.id, mode);

		return cast(T) this;
	}

	/**
	 * Set the maximum value of the progress bar.
	 *
	 * Params:
	 *     maximum = The maximum value of the progress bar.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto setMaximumValue(this T)(double maximum)
	{
		this._tk.eval("%s configure -maximum %s", this.id, maximum);

		return cast(T) this;
	}

	/**
	 * The widget periodically increments the value of this option whenever the 
	 * -value is greater than 0 and, in determinate mode, less than -maximum. 
	 * This option may be used by the current theme to provide additional 
	 * animation effects.
	 *
	 * Returns:
	 *     A string containing the phase value.
	 */
	public string getPhase()
	{
		this._tk.eval("%s cget -phase", this.id);
		return this._tk.getResult!(string);
	}

	/**
	 * Begin autoincrement mode: schedules a recurring timer event that calls 
	 * step every interval.
	 *
	 * Params:
	 *     milliseconds = The interval between steps.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto start(this T)(int milliseconds = 50)
	{
		this._tk.eval("%s start %s", this.id, milliseconds);

		return cast(T) this;
	}

	/**
	 * Increments the progress bar by an amount.
	 *
	 * Params:
	 *     increment = The amount to increment by.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto step(this T)(int increment = 1)
	{
		this._tk.eval("%s step %s", this.id, increment);

		return cast(T) this;
	}

	/**
	 * Stop autoincrement mode: cancels any recurring timer event initiated by 
	 * the start method.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 *
	 * See_Also:
	 *     $(LINK2 ./progressbar.html#ProgressBar.start, start) $(BR)
	 */
	public auto stop(this T)()
	{
		this._tk.eval("%s stop", this.id);

		return cast(T) this;
	}

	/**
	 * Mixin common commands.
	 */
	mixin Length;
	mixin Value!(this._valueVariable, double);
}
