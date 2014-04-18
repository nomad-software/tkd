/**
 * Dialog module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.dialog.fontchooser;

/**
 * Imports.
 */
import tkd.element.element;
import tkd.tkdapplication : Window;

/**
 * The fontchooser dialog allows users to choose a font installed on the 
 * system. It uses the native platform font selection dialog where available, 
 * or a dialog implemented in Tcl/Tk otherwise. Unlike most of the other 
 * dialogs, the fontchooser does not return an immediate result because on some 
 * platforms (Mac OSX) the standard font dialog is modeless while on others 
 * (Windows) it is modal. To accommodate this difference, all user interaction 
 * with the dialog will be communicated to the caller via commands or virtual 
 * events.
 *
 * Additional_Events:
 *     Additional events that can also be bound to using the $(LINK2 ../element/uielement.html#UiElement.bind, bind) method.
 *     $(P
 *         &lt;&lt;TkFontchooserFontChanged&gt;&gt;,
 *         &lt;&lt;TkFontchooserVisibility&gt;&gt;,
 *     )
 */
class FontChooser : Element
{
	/**
	 * The title of the dialog.
	 */
	private string _title;

	/**
	 * The name of the callback to execute when a new font is choosen.
	 */
	private string _command;

	/**
	 * Construct the dialog.
	 *
	 * Params:
	 *     title = The title of the dialog.
	 */
	this(string title = "Font")
	{
		this._elementId = "dialog";

		this._title = title;
	}

	/**
	 * Set the callback to execute when a new font is choosen. When the 
	 * callback is executed the font choosen is stored in the CommandArgs 
	 * struct.
	 *
	 * Params:
	 *     callback = The delegate callback to execute when invoking the command.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 *
	 * See_Also:
	 *     $(LINK2 ../element/element.html#CommandArgs, tkd.element.element.CommandArgs) $(BR)
	 *     $(LINK2 ../element/element.html#CommandCallback, tkd.element.element.CommandCallback) $(BR)
	 */
	public auto setCommand(this T)(CommandCallback callback)
	{
		this._command = this.createCommand(callback);
		this.configureDialog();

		return cast(T) this;
	}

	/**
	 * Remove a previously set command.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto removeCommand(this T)()
	{
		this._command = "";
		this._tk.deleteCommand(this.getCommandName());
		this.configureDialog();

		return cast(T) this;
	}

	/**
	 * Configure the dialog with the various properties.
	 */
	private void configureDialog()
	{
		this._tk.eval("tk fontchooser configure -title {%s} -command {%s}", this._title, this._command);
	}

	/**
	 * Show the dialog.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto show(this T)()
	{
		this._tk.eval("tk fontchooser show");

		return cast(T) this;
	}

	/**
	 * Hide the dialog.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto hide(this T)()
	{
		this._tk.eval("tk fontchooser hide");

		return cast(T) this;
	}

	/**
	 * Check if the dialog is visible.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public bool isVisible()
	{
		this._tk.eval("tk fontchooser configure -visible");

		return this._tk.getResult!(int) == 1;
	}
}
