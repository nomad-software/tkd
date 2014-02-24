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
 * Class representing a checkbutton widget.
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
	this(UiElement parent = null, string text = null)
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
	 */
	public void check()
	{
		return this._tk.setVariable(this._valueVariable, this._onValue);
	}

	/**
	 * Uncheck the check button.
	 */
	public void unCheck()
	{
		return this._tk.setVariable(this._valueVariable, this._offValue);
	}

	/**
	 * Only half check the check button. This is a kind of halfway state.
	 */
	public void halfCheck()
	{
		return this._tk.setVariable(this._valueVariable, "");
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
	 */
	public void setOnValue(string value)
	{
		this._onValue = value;
		this._tk.eval("%s configure -onvalue %s", this.id, this._onValue);
	}

	/**
	 * Set the value of the unchecked state.
	 *
	 * Params:
	 *     value = The value of the widget for the unchecked state.
	 */
	public void setOffValue(string value)
	{
		this._offValue = value;
		this._tk.eval("%s configure -offvalue %s", this.id, this._offValue);
	}

	/**
	 * Mixin common commands.
	 */
	mixin Invoke;
	mixin Command;
	mixin Value!(this._valueVariable);
}
