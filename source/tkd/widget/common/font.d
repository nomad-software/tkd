/**
* Font module.
*
* License:
*     MIT. See LICENSE for full details.
*/
module tkd.widget.common.font;

/**
* These are common commands that apply to all widgets that have them injected.
*/
mixin template Font()
{  
	/**
	 * Set the font and style for the widget.
	 *
	 * Params:
	 *     font   = The string containing all the specified font options.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 *
	 * Example:
	 * ---
	 * widget.setFont("PragmataPro", 10, FontStyle.bold, FontStyle.italic);
	 * ---
	 *
	 * See_Also:
	 *     $(LINK2 ../../element/fontstyle.html, tkd.element.fontstyle) for font styles.
	 */
	public auto setFont(this T)(string font)
	{
		this._tk.eval("%s configure -font {%s}", this.id, font);

		return cast(T) this;
	}

	/**
	 * Set the font and style for the widget via a simple string.
	 * This method is exists to set the font using the output of the font dialog.
	 *
	 * Params:
	 *     fontInfo = The output of the file dialog.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 *
	 * Example:
	 * ---
	 * auto dialog = new FontDialog("Choose a font")
	 *     .setCommand(delegate(CommandArgs args){
	 *         widget.setFont(args.dialog.font);
	 *     })
	 *     .show();
	 * ---
	 * See_Also:
	 *     $(LINK2 ../../window/dialog/fontdialog.html, tkd.window.dialog.fontdialog) for how to recieve output.
	 */
	public auto setFont(this T)(string fontInfo)
	{
		this._tk.eval("%s configure -font {%s}", this.id, fontInfo);

		return cast(T) this;
	}
}
