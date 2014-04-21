/**
 * Dialog module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.dialog.colordialog;

/**
 * Imports.
 */
import std.regex;
import tkd.dialog.dialog;
import tkd.element.color;

/**
 * pops up a dialog box for the user to select a color.
 *
 * Result:
 *     The web style hex color selected.
 *
 * See_Also:
 *     $(LINK2 ./dialog.html, tkd.dialog.dialog) $(BR)
 */
class ColorDialog : Dialog
{
	/**
	 * The initial color to display in the dialog.
	 */
	private string _inititalColor = Color.white;

	/**
	 * Construct the dialog.
	 *
	 * Params:
	 *     parent = The parent window of the dialog.
	 *     title = The title of the dialog.
	 */
	this(Window parent, string title = "Color")
	{
		super(parent, title);
	}

	/**
	 * Construct the dialog.
	 *
	 * Params:
	 *     title = The title of the dialog.
	 */
	this(string title = "Color")
	{
		this(null, title);
	}

	/**
	 * Set the initial color to display in the dialog.
	 * Use colors from the preset color $(LINK2 ../element/color.html, list) or a web style hex color.
	 *
	 * Params:
	 *     color = The initial color.
	 *
	 * Returns:
	 *     This dialog to aid method chaining.
	 *
	 * See_Also:
	 *     $(LINK2 ../element/color.html, tkd.widget.color) $(BR)
	 *
	 * Caveats:
	 *     If the passed color is not recognised the dialog will fail to show.
	 */
	public auto setInitialColor(this T)(string color)
	{
		this._inititalColor = color;

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
			this._tk.eval("tk_chooseColor -parent %s -title {%s} -initialcolor {%s}", this._parent.id, this._title, this._inititalColor);
		}
		else
		{
			this._tk.eval("tk_chooseColor -title {%s} -initialcolor {%s}", this._title, this._inititalColor);
		}

		string result = this._tk.getResult!(string);

		if (match(result, r"^unknown color name").empty)
		{
			this._result = result;
		}

		return cast(T) this;
	}
}
