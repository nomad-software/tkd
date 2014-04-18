/**
 * Widget module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.radiobutton;

/**
 * Imports.
 */
import std.string;
import tkd.element.uielement;
import tkd.widget.common.command;
import tkd.widget.common.invoke;
import tkd.widget.common.value;
import tkd.widget.textwidget;

/**
 * Radio button widgets are used in groups to show or change a set of 
 * mutually-exclusive options. Radio buttons have an associated selected value; 
 * when a radio button is selected, it sets the associated value.
 *
 * To create a group of radio button that work properly in unison, all radio 
 * button widgets within the group must share the same immediate parent 
 * (usually a frame) and all must have individual selected values set.
 *
 * Common_Commands:
 *     These are injected common commands that can also be used with this widget.
 *     $(P
 *         $(LINK2 ./common/command.html, Command) $(BR)
 *         $(LINK2 ./common/invoke.html, Invoke) $(BR)
 *         $(LINK2 ./common/value.html, Value) $(BR)
 *     )
 *
 * Additional_Events:
 *     Additional events that can also be bound to using the $(LINK2 ../element/uielement.html#UiElement.bind, bind) method.
 *     $(P
 *         &lt;&lt;Invoke&gt;&gt;,
 *         &lt;&lt;PrevWindow&gt;&gt;,
 *         &lt;Alt-Key&gt;,
 *         &lt;B1-Enter&gt;,
 *         &lt;B1-Leave&gt;,
 *         &lt;Button-1&gt;,
 *         &lt;ButtonRelease-1&gt;,
 *         &lt;Enter&gt;,
 *         &lt;Key-Down&gt;,
 *         &lt;Key-F10&gt;,
 *         &lt;Key-Tab&gt;,
 *         &lt;Key-Up&gt;,
 *         &lt;Key-space&gt;,
 *         &lt;Leave&gt;,
 *     )
 *
 * States:
 *     This widget does not respond to user input if the disabled state is set. 
 *     The widget sets the selected state whenever the value to set to the 
 *     selected value, and clears it otherwise. This widget sets the alternate 
 *     state whenever value is unset. (The alternate state may be used to 
 *     indicate a "tri-state" or "indeterminate" selection.)
 *
 * Styles:
 *     Radio button widgets support the Toolbutton style in all standard 
 *     themes, which is useful for creating widgets for toolbars.
 *
 * See_Also:
 *     $(LINK2 ./textwidget.html, tkd.widget.textwidget) $(BR)
 */
class RadioButton : TextWidget
{
	/**
	 * The name of the variable that contains the widget's value.
	 */
	private string _valueVariable;

	/**
	 * The value of the radio button if it's selected.
	 * The default is '1'.
	 */
	private string _selectedValue = "1";

	/**
	 * Construct the widget.
	 *
	 * Params:
	 *     parent = The parent of this widget.
	 *     text = The text of the button.
	 *
	 * See_Also:
	 *     $(LINK2 ../element/uielement.html, tkd.element.uielement) $(BR)
	 */
	this(UiElement parent, string text)
	{
		super(parent);
		this._elementId = "radiobutton";

		if (parent is null)
		{
			this._valueVariable = format("variable-%s", this.generateHash(this._elementId));
		}
		else
		{
			this._valueVariable = format("variable-%s", this.generateHash("%s%s", this._elementId, parent.id));
		}

		this._tk.eval("ttk::radiobutton %s -textvariable %s -variable %s", this.id, this._textVariable, this._valueVariable);

		this.setText(text);
	}

	/**
	 * Construct the widget.
	 *
	 * Params:
	 *     text = The text of the button.
	 */
	this(string text)
	{
		this(null, text);
	}

	/**
	 * Get the value of the selected state.
	 *
	 * Returns:
	 *     A string contain the value of the selected state.
	 */
	public string getSelectedValue()
	{
		return this._selectedValue;
	}

	/**
	 * Set the value of the selected state.
	 *
	 * Params:
	 *     value = The value of the widget for the selected state.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto setSelectedValue(this T)(string value)
	{
		this._selectedValue = value;
		this._tk.eval("%s configure -value %s", this.id, this._selectedValue);

		return cast(T) this;
	}

	/**
	 * Select the radio button and execute the command if bound.
	 */
	public auto select(this T)()
	{
		this._tk.setVariable(this._valueVariable, this._selectedValue);

		return cast(T) this;
	}

	/**
	 * Mixin common commands.
	 */
	mixin Command;
	mixin Invoke;
	mixin Value!(this._valueVariable, string);
}
