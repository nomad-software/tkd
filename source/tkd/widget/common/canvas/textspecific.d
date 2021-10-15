/**
 * Text specific module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.common.canvas.textspecific;

/**
 * These are common commands that apply to all widgets that have them injected.
 */
mixin template TextSpecific()
{
	import std.conv;
	import std.typecons : Nullable;

	/**
	 * The angle of the text.
	 */
	private Nullable!(double) _angle;

	/**
	 * The font.
	 */
	private string _font;

	/**
	 * The alignment.
	 */
	private string _alignment;

	/**
	 * The text.
	 */
	private string _text;

	/**
	 * The maximum line length.
	 */
	private Nullable!(int) _maxLineLength;

	/**
	 * Get the text angle.
	 *
	 * Returns:
	 *     The text angle.
	 */
	public double getAngle()
	{
		if (this._parent)
		{
			this._tk.eval("%s itemcget %s -angle", this._parent.id, this.id);
			this._angle = this._tk.getResult!(double);
		}

		return this._angle.isNull ? 0.0 : this._angle.get;
	}

	/**
	 * Specifies how many degrees to rotate the text anticlockwise about the 
	 * positioning point for the text; it may have any floating-point value 
	 * from 0.0 to 360.0. For example, if rotationDegrees is 90, then the text 
	 * will be drawn vertically from bottom to top. This option defaults to 
	 * 0.0. Degrees is given in units of degrees measured counter-clockwise 
	 * from the 3-o'clock position; it may be either positive or negative.
	 *
	 * Params:
	 *    angle = The text angle.
	 *
	 * Returns:
	 *     This item to aid method chaining.
	 */
	public auto setAngle(this T, A)(A angle) if (is(A == double) || is(A == Nullable!(double)))
	{
		static if (is(A == Nullable!(double)))
		{
			if (angle.isNull)
			{
				return cast(T) this;
			}
		}

		this._angle = angle;

		if (this._parent)
		{
			this._tk.eval("%s itemconfigure %s -angle %s", this._parent.id, this.id, this._angle);
		}

		return cast(T) this;
	}

	/**
	 * Get the font.
	 *
	 * Returns:
	 *     The font.
	 */
	public string getFont()
	{
		if (this._parent)
		{
			this._tk.eval("%s itemcget %s -font", this._parent.id, this.id);
			this._font = this._tk.getResult!(string);
		}

		return this._font;
	}

	/**
	 * Specifies the font to use for the text item. The format of the string to 
	 * pass when specifing a font is as follows.
	 *
	 * "Times New Roman" [[12] [bold] [italic] [overstrike] [underline]]
	 *
	 * Params:
	 *    font = The font.
	 *
	 * Returns:
	 *     This item to aid method chaining.
	 */
	public auto setFont(this T)(string font)
	{
		this._font = font;

		if (this._parent && this._font.length)
		{
			// String concatentation is used here to avoid the character escaping done on args.
			this._tk.eval("%s itemconfigure %s -font {"~ this._font ~"}", this._parent.id, this.id);
		}

		return cast(T) this;
	}

	/**
	 * Get the alignment
	 *
	 * Returns:
	 *     The alignment.
	 */
	public string getAlignment()
	{
		if (this._parent)
		{
			this._tk.eval("%s itemcget %s -justify", this._parent.id, this.id);
			this._alignment = this._tk.getResult!(string);
		}

		return this._alignment;
	}

	/**
	 * Specifies how to justify the text within its bounding region.
	 *
	 * Params:
	 *    alignment = The alignment.
	 *
	 * Returns:
	 *     This item to aid method chaining.
	 *
	 * See_Also:
	 *     $(LINK2 ./alignment.html, tkd.widget.alignment)
	 */
	public auto setAlignment(this T)(string alignment)
	{
		this._alignment = alignment;

		if (this._parent && this._alignment.length)
		{
			this._tk.eval("%s itemconfigure %s -justify {%s}", this._parent.id, this.id, this._alignment);
		}

		return cast(T) this;
	}

	/**
	 * Get the text.
	 *
	 * Returns:
	 *     The text.
	 */
	public string getText()
	{
		if (this._parent)
		{
			this._tk.eval("%s itemcget %s -text", this._parent.id, this.id);
			this._text = this._tk.getResult!(string);
		}

		return this._text;
	}

	/**
	 * Specifies the characters to be displayed in the text item.  Newline 
	 * characters cause line breaks.
	 *
	 * Params:
	 *    text = The text.
	 *
	 * Returns:
	 *     This item to aid method chaining.
	 */
	public auto setText(this T)(string text)
	{
		this._text = text;

		if (this._parent && this._text.length)
		{
			// String concatenation is used to build the script here instead of 
			// using format specifiers to enable supporting input which 
			// includes Tcl/Tk reserved characters and elements that could be 
			// construed as format specifiers.
			string script = std.conv.text(this._parent.id, ` itemconfigure `, this.id, ` -text "`, this._tk.escape(this._text), `"`);
			this._tk.eval(script);
		}

		return cast(T) this;
	}

	/**
	 * Get max line length.
	 *
	 * Returns:
	 *     The max line length.
	 */
	public int getMaxLineLength()
	{
		if (this._parent)
		{
			this._tk.eval("%s itemcget %s -width", this._parent.id, this.id);
			this._maxLineLength = this._tk.getResult!(int);
		}

		return this._maxLineLength.isNull ? 0 : this._maxLineLength.get;
	}

	/**
	 * Specifies a maximum line length for the text. If this option is zero 
	 * (the default) the text is broken into lines only at newline characters.  
	 * However, if this option is non-zero then any line that would be longer 
	 * than line length is broken just before a space character to make the 
	 * line shorter than lineLength; the space character is treated as if it 
	 * were a newline character.
	 *
	 * Params:
	 *    maxLineLength = The max line length.
	 *
	 * Returns:
	 *     This item to aid method chaining.
	 */
	public auto setMaxLineLength(this T, L)(L maxLineLength) if (is(L == int) || is(L == Nullable!(int)))
	{
		static if (is(L == Nullable!(int)))
		{
			if (maxLineLength.isNull)
			{
				return cast(T) this;
			}
		}

		this._maxLineLength = maxLineLength;

		if (this._parent)
		{
			this._tk.eval("%s itemconfigure %s -width %s", this._parent.id, this.id, this._maxLineLength);
		}

		return cast(T) this;
	}
}
