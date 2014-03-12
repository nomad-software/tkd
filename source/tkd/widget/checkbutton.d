/**
 * Widget module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.checkbutton;

/**
 * Imports.
 */
import tkd.element.uielement;
import tkd.widget.common.command;
import tkd.widget.common.invoke;
import tkd.widget.common.value;
import tkd.widget.textwidget;

/**
 * A checkbutton widget is used to show or change a setting. It has two states, 
 * selected and deselected. The state of the checkbutton may be linked to a 
 * value.
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
 *         &lt;Key-F10&gt;,
 *         &lt;Key-Tab&gt;,
 *         &lt;Key-space&gt;,
 *         &lt;Leave&gt;,
 *     )
 *
 * States:
 *     This widget does not respond to user input if the disabled state is set. 
 *     The widget sets the selected state whenever the value is set to the 
 *     widget's on-value, and clears it otherwise. The widget sets the 
 *     alternate state whenever the value is unset. (The alternate state may be 
 *     used to indicate a "tri-state" or "indeterminate" selection.)
 *
 * Styles:
 *     Check button widgets support the Toolbutton style in all standard 
 *     themes, which is useful for creating widgets for toolbars.
 *
 * See_Also:
 *     $(LINK2 ./textwidget.html, tkd.widget.textwidget)
 */
class CheckButton : TextWidget
{
	/**
	 * The name of the variable that contains the widget's value.
	 */
	private string _valueVariable;

	/**
	 * The value of the checkbutton if it's checked.
	 * The default is '1'.
	 */
	private string _onValue = "1";

	/**
	 * The value of the checkbutton if it's unchecked.
	 * The default is '1'.
	 */
	private string _offValue = "0";

	/**
	 * Construct the widget.
	 *
	 * Params:
	 *     parent = An optional parent of this widget.
	 *     text = The text of the checkbutton.
	 *
	 * See_Also:
	 *     $(LINK2 ../element/uielement.html, tkd.element.uielement)
	 */
	this(UiElement parent, string text = null)
	{
		super(parent);
		this._elementId     = "checkbutton";
		this._valueVariable = format("variable-%s", this.generateHash(this.id));

		this._tk.eval("ttk::checkbutton %s -textvariable %s -variable %s", this.id, this._textVariable, this._valueVariable);

		this.setText(text);
		this.unCheck();
	}

	/**
	 * Construct the widget.
	 *
	 * Params:
	 *     text = The text of the checkbutton.
	 */
	this(string text = null)
	{
		this(null, text);
	}

	/**
	 * Check the check button.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto check(this T)()
	{
		this._tk.setVariable(this._valueVariable, this._onValue);

		return cast(T) this;
	}

	/**
	 * Uncheck the check button.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto unCheck(this T)()
	{
		this._tk.setVariable(this._valueVariable, this._offValue);

		return cast(T) this;
	}

	/**
	 * Only half check the check button. This is a kind of halfway state.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto halfCheck(this T)()
	{
		this._tk.setVariable(this._valueVariable, "");

		return cast(T) this;
	}

	/**
	 * Check if the check button is checked or not.
	 *
	 * Returns:
	 *     true if the check button is checked, false if not.
	 */
	public bool isChecked()
	{
		return this._tk.getVariable(this._valueVariable) == this._onValue;
	}

	/**
	 * Set the value of the checked state.
	 *
	 * Params:
	 *     value = The value of the widget for the checked state.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto setOnValue(this T)(string value)
	{
		this._onValue = value;
		this._tk.eval("%s configure -onvalue %s", this.id, this._onValue);

		return cast(T) this;
	}

	/**
	 * Set the value of the unchecked state.
	 *
	 * Params:
	 *     value = The value of the widget for the unchecked state.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto setOffValue(this T)(string value)
	{
		this._offValue = value;
		this._tk.eval("%s configure -offvalue %s", this.id, this._offValue);

		return cast(T) this;
	}

	/**
	 * Mixin common commands.
	 */
	mixin Invoke;
	mixin Command;
	mixin Value!(this._valueVariable, string);
}
