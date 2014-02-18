/**
 * Insert module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.common.insert;

/**
 * These are common commands that apply to all widgets that have them injected.
 */
mixin template Insert()
{
	/**
	 * Insert text at an index.
	 *
	 * Params:
	 *     text = The text to insert.
	 *     charIndex = The index to insert the text.
	 */
	public void insertTextAt(string text, int charIndex)
	{
		this._tk.eval("%s insert %s %s", this.id, charIndex, text);
	}

	/**
	 * Append text to the end.
	 *
	 * Params:
	 *     text = The text to insert.
	 */
	public void appendText(string text)
	{
		this._tk.eval("%s insert end %s", this.id, text);
	}

	/**
	 * Insert text at the cursor position.
	 *
	 * Params:
	 *     text = The text to insert.
	 *
	 * See_Also:
	 *     $(LINK2 ./cursor.html, tkd.widget.common.cursor) $(BR)
	 *     $(LINK2 ./index.html, tkd.widget.common.index) $(BR)
	 */
	public void insertTextAtCursor(string text)
	{
		this._tk.eval("%s insert insert %s", this.id, text);
	}
}
