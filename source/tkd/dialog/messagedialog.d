/**
 * Dialog module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.dialog.messagedialog;

/**
 * Imports.
 */
import std.regex;
import tkd.dialog.dialog;
import tkd.dialog.messagedialogicon;
import tkd.dialog.messagedialogtype;

/**
 * pops up a dialog box with a user defined message and buttons.
 *
 * Result:
 *     The symbolic name of the button pressed.
 *
 * See_Also:
 *     $(LINK2 ./dialog.html, tkd.dialog.dialog) $(BR)
 */
class MessageDialog : Dialog
{
	/**
	 * The symbolic name of the default button for this message window ('ok', 
	 * 'cancel', and so on).
	 */
	private string _defaultButton;

	/**
	 * Specifies an auxiliary message to the main message.
	 */
	private string _detailMessage;

	/**
	 * Specifies an icon to display.
	 */
	private string _icon = MessageDialogIcon.info;

	/**
	 * Specifies the message to display in this message box.
	 */
	private string _message;

	/**
	 * Arranges for a predefined set of buttons to be displayed.
	 */
	private string _type = MessageDialogType.ok;

	/**
	 * Construct the dialog.
	 *
	 * Params:
	 *     parent = The parent window of the dialog.
	 *     title = The title of the dialog.
	 */
	this(Window parent, string title = "Information")
	{
		super(parent, title);
	}

	/**
	 * Construct the dialog.
	 *
	 * Params:
	 *     title = The title of the dialog.
	 */
	this(string title = "Information")
	{
		this(null, title);
	}

	/**
	 * Set the default button.
	 *
	 * Params:
	 *     button = The default button to use.
	 *
	 * Returns:
	 *     This dialog to aid method chaining.
	 *
	 * See_Also:
	 *     $(LINK2 ./messagedialogbutton.html, tkd.dialog.messagedialogbutton) $(BR)
	 */
	public auto setDefaultButton(this T)(string button)
	{
		this._defaultButton = button;

		return cast(T) this;
	}

	/**
	 * Set the detail message. The message detail will be presented beneath the 
	 * main message and, where supported by the OS, in a less emphasized font 
	 * than the main message.
	 *
	 * Params:
	 *     message = The detail message.
	 *
	 * Returns:
	 *     This dialog to aid method chaining.
	 */
	public auto setDetailMessage(this T)(string message)
	{
		this._detailMessage = message;

		return cast(T) this;
	}

	/**
	 * Set the preset dialog icon. It must be one of the following: error, 
	 * info, question or warning.
	 *
	 * Params:
	 *     icon = The preset dialog icon.
	 *
	 * Returns:
	 *     This dialog to aid method chaining.
	 *
	 * See_Also:
	 *     $(LINK2 ./messagedialogicon.html, tkd.dialog.messagedialogicon) $(BR)
	 */
	public auto setIcon(this T)(string icon)
	{
		this._icon = icon;

		return cast(T) this;
	}

	/**
	 * Set the main message to display in the message dialog.
	 *
	 * Params:
	 *     message = The message.
	 *
	 * Returns:
	 *     This dialog to aid method chaining.
	 */
	public auto setMessage(this T)(string message)
	{
		this._message = message;

		return cast(T) this;
	}

	/**
	 * Set the message dialog type. Arranges for a predefined set of buttons to 
	 * be displayed.
	 *
	 * Params:
	 *     type = The type of the message dialog.
	 *
	 * Returns:
	 *     This dialog to aid method chaining.
	 *
	 * See_Also:
	 *     $(LINK2 ./messagedialogtype.html, tkd.dialog.messagedialogtype) $(BR)
	 */
	public auto setType(this T)(string type)
	{
		this._type = type;

		return cast(T) this;
	}

	/**
	 * Show the dialog.
	 *
	 * Returns:
	 *     This dialog to aid method chaining.
	 */
	public auto show(this T)()
	{
		if (this._parent)
		{
			this._tk.eval("tk_messageBox -parent %s -title {%s} -default {%s} -detail {%s} -icon {%s} -message {%s} -type {%s}", this._parent.id, this._title, this._defaultButton, this._detailMessage, this._icon, this._message, this._type);
		}
		else
		{
			this._tk.eval("tk_messageBox -title {%s} -default {%s} -detail {%s} -icon {%s} -message {%s} -type {%s}", this._title, this._defaultButton, this._detailMessage, this._icon, this._message, this._type);
		}

		string result = this._tk.getResult!(string);
		this._result = result;

		return cast(T) this;
	}
}
