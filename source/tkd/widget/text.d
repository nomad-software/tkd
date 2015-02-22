/**
 * Widget module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.text;

/**
 * Imports.
 */
import std.conv;
import tkd.element.uielement;
import tkd.image.image;
import tkd.widget.common.border;
import tkd.widget.common.height;
import tkd.widget.common.relief;
import tkd.widget.common.width;
import tkd.widget.common.xscrollcommand;
import tkd.widget.common.xview;
import tkd.widget.common.yscrollcommand;
import tkd.widget.common.yview;
import tkd.widget.textwrapmode;
import tkd.widget.widget;

/**
 * A text widget displays one or more lines of text and allows that text to be 
 * edited. Text widgets support embedded widgets or embedded images.
 *
 * Example:
 * ---
 * auto text = new Text()
 * 	.appendText("Text")
 * 	.pack();
 * ---
 *
 * Common_Commands:
 *     These are injected common commands that can also be used with this widget.
 *     $(P
 *         $(LINK2 ./common/border.html, Border) $(BR)
 *         $(LINK2 ./common/height.html, Height) $(BR)
 *         $(LINK2 ./common/relief.html, Relief) $(BR)
 *         $(LINK2 ./common/width.html, Width) $(BR)
 *         $(LINK2 ./common/xscrollcommand.html, XScrollCommand) $(BR)
 *         $(LINK2 ./common/xview.html, XView) $(BR)
 *         $(LINK2 ./common/yscrollcommand.html, YScrollCommand) $(BR)
 *         $(LINK2 ./common/yview.html, YView) $(BR)
 *     )
 *
 * Additional_Events:
 *     Additional events that can also be bound to using the $(LINK2 ../element/uielement.html#UiElement.bind, bind) method.
 *     $(P
 *         &lt;&lt;Clear&gt;&gt;,
 *         &lt;&lt;Copy&gt;&gt;,
 *         &lt;&lt;Cut&gt;&gt;,
 *         &lt;&lt;Modified&gt;&gt;,
 *         &lt;&lt;Paste&gt;&gt;,
 *         &lt;&lt;PasteSelection&gt;&gt;,
 *         &lt;&lt;PrevWindow&gt;&gt;,
 *         &lt;&lt;Redo&gt;&gt;,
 *         &lt;&lt;Selection&gt;&gt;,
 *         &lt;&lt;Undo&gt;&gt;,
 *         &lt;Alt-Key&gt;,
 *         &lt;B1-Enter&gt;,
 *         &lt;B1-Leave&gt;,
 *         &lt;B1-Motion&gt;,
 *         &lt;B2-Motion&gt;,
 *         &lt;Button-1&gt;,
 *         &lt;Button-2&gt;,
 *         &lt;Button-4&gt;,
 *         &lt;Button-5&gt;,
 *         &lt;ButtonRelease-1&gt;,
 *         &lt;Control-Button-1&gt;,
 *         &lt;Control-Key-Down&gt;,
 *         &lt;Control-Key-End&gt;,
 *         &lt;Control-Key-Home&gt;,
 *         &lt;Control-Key-Left&gt;,
 *         &lt;Control-Key-Next&gt;,
 *         &lt;Control-Key-Prior&gt;,
 *         &lt;Control-Key-Right&gt;,
 *         &lt;Control-Key-Tab&gt;,
 *         &lt;Control-Key-Up&gt;,
 *         &lt;Control-Key-a&gt;,
 *         &lt;Control-Key-b&gt;,
 *         &lt;Control-Key-backslash&gt;,
 *         &lt;Control-Key-d&gt;,
 *         &lt;Control-Key-e&gt;,
 *         &lt;Control-Key-f&gt;,
 *         &lt;Control-Key-h&gt;,
 *         &lt;Control-Key-i&gt;,
 *         &lt;Control-Key-k&gt;,
 *         &lt;Control-Key-n&gt;,
 *         &lt;Control-Key-o&gt;,
 *         &lt;Control-Key-p&gt;,
 *         &lt;Control-Key-slash&gt;,
 *         &lt;Control-Key-space&gt;,
 *         &lt;Control-Key-t&gt;,
 *         &lt;Control-Key&gt;,
 *         &lt;Control-Shift-Key-Down&gt;,
 *         &lt;Control-Shift-Key-End&gt;,
 *         &lt;Control-Shift-Key-Home&gt;,
 *         &lt;Control-Shift-Key-Left&gt;,
 *         &lt;Control-Shift-Key-Right&gt;,
 *         &lt;Control-Shift-Key-Tab&gt;,
 *         &lt;Control-Shift-Key-Up&gt;,
 *         &lt;Control-Shift-Key-space&gt;,
 *         &lt;Double-Button-1&gt;,
 *         &lt;Double-Shift-Button-1&gt;,
 *         &lt;Key-BackSpace&gt;,
 *         &lt;Key-Delete&gt;,
 *         &lt;Key-Down&gt;,
 *         &lt;Key-End&gt;,
 *         &lt;Key-Escape&gt;,
 *         &lt;Key-F10&gt;,
 *         &lt;Key-Home&gt;,
 *         &lt;Key-Insert&gt;,
 *         &lt;Key-KP_Enter&gt;,
 *         &lt;Key-Left&gt;,
 *         &lt;Key-Next&gt;,
 *         &lt;Key-Prior&gt;,
 *         &lt;Key-Return&gt;,
 *         &lt;Key-Right&gt;,
 *         &lt;Key-Select&gt;,
 *         &lt;Key-Tab&gt;,
 *         &lt;Key-Up&gt;,
 *         &lt;Key&gt;,
 *         &lt;Meta-Key-BackSpace&gt;,
 *         &lt;Meta-Key-Delete&gt;,
 *         &lt;Meta-Key-b&gt;,
 *         &lt;Meta-Key-d&gt;,
 *         &lt;Meta-Key-f&gt;,
 *         &lt;Meta-Key-greater&gt;,
 *         &lt;Meta-Key-less&gt;,
 *         &lt;Meta-Key&gt;,
 *         &lt;MouseWheel&gt;,
 *         &lt;Shift-Button-1&gt;,
 *         &lt;Shift-Key-Down&gt;,
 *         &lt;Shift-Key-End&gt;,
 *         &lt;Shift-Key-Home&gt;,
 *         &lt;Shift-Key-Left&gt;,
 *         &lt;Shift-Key-Next&gt;,
 *         &lt;Shift-Key-Prior&gt;,
 *         &lt;Shift-Key-Right&gt;,
 *         &lt;Shift-Key-Select&gt;,
 *         &lt;Shift-Key-Tab&gt;,
 *         &lt;Shift-Key-Up&gt;,
 *         &lt;Triple-Button-1&gt;,
 *         &lt;Triple-Shift-Button-1&gt;,
 *     )
 *
 * See_Also:
 *     $(LINK2 ./widget.html, tkd.widget.widget)
 */
class Text : Widget, IXScrollable!(Text), IYScrollable!(Text)
{
	/**
	 * Construct the widget.
	 *
	 * Params:
	 *     parent = The parent of this widget.
	 *
	 * See_Also:
	 *     $(LINK2 ../element/uielement.html, tkd.element.UiElement) $(BR)
	 */
	public this(UiElement parent = null)
	{
		super(parent);
		this._elementId = "text";

		this._tk.eval("text %s -highlightthickness 0", this.id);

		this.setUndoSupport(true);
		this.setUndoLevels(25);
		this.setWrapMode(TextWrapMode.word);
	}

	/**
	 * Set the amount of padding in the text widget.
	 *
	 * Params:
	 *     padding = The amount of padding in the text widget.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto setPadding(this T)(int padding)
	{
		this._tk.eval("%s configure -padx %s -pady %s", this.id, padding, padding);

		return cast(T) this;
	}

	/**
	 * Set if the widget is readonly or not.
	 *
	 * Params:
	 *     readOnly = Flag to toggle readonly state.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto setReadOnly(this T)(bool readOnly = true)
	{
		if(readOnly)
		{
			this._tk.eval("%s configure -state disabled", this.id);
		}
		else
		{
			this._tk.eval("%s configure -state normal", this.id);
		}

		return cast(T) this;
	}

	/**
	 * Enable or disable undo support.
	 *
	 * Params:
	 *     enable = True to enable undo support, false to disable it.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto setUndoSupport(this T)(bool enable)
	{
		this._tk.eval("%s configure -undo %s", this.id, enable);

		return cast(T) this;
	}

	/**
	 * Set the number of undo levels the widget will support.
	 *
	 * Params:
	 *     undoLevels = The number of undo levels the widget will support.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto setUndoLevels(this T)(int undoLevels)
	{
		this._tk.eval("%s configure -maxundo %s", this.id, undoLevels);

		return cast(T) this;
	}

	/**
	 * Set the wrap mode of the text.
	 *
	 * Params:
	 *     mode = The mode to wrap the text with.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 *
	 * See_Also:
	 *     $(LINK2 ./textwrapmode.html, tkd.widget.textwrapmode)
	 */
	public auto setWrapMode(this T)(string mode)
	{
		this._tk.eval("%s configure -wrap %s", this.id, mode);

		return cast(T) this;
	}

	/**
	 * Appends text to the widget.
	 *
	 * Params:
	 *     text = The text to append.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto appendText(this T)(string text)
	{
		// String concatenation is used to build the script here instead of 
		// using format specifiers to enable supporting input which includes 
		// Tcl/Tk reserved characters and elements that could be construed as 
		// format specifiers.
		string script = std.conv.text(this.id, ` insert end "`, this._tk.escape(text), `"`);
		this._tk.eval(script);

		return cast(T) this;
	}

	/**
	 * Inserts text into the widget at a specified line and character index.
	 *
	 * Params:
	 *     line = The line at which to insert the text. Indexes start at 1.
	 *     character = The character at which to insert the text. Indexes start at 0.
	 *     text = The text to insert.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto insertText(this T)(int line, int character, string text)
	{
		// String concatenation is used to build the script here instead of 
		// using format specifiers to enable supporting input which includes 
		// Tcl/Tk reserved characters and elements that could be construed as 
		// format specifiers.
		string script = std.conv.text(this.id, ` insert `, line, `.`, character, ` "`, this._tk.escape(text), `"`);
		this._tk.eval(script);

		return cast(T) this;
	}

	/**
	 * Get the text from the widget.
	 *
	 * Returns:
	 *     The text from the widget.
	 */
	public string getText(this T)()
	{
		this._tk.eval("%s get 0.0 end", this.id);

		return this._tk.getResult!(string);
	}

	/**
	 * Delete text from the widget.
	 *
	 * Params:
	 *     fromLine = The line from which to start deleting. Indexes start at 1.
	 *     fromChar = The character from which to start deleting. Indexes start at 0.
	 *     toLine = The line up to (but not including) which to delete. Indexes start at 1.
	 *     toChar = The character up to (but not including) which to delete. Indexes start at 0.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto deleteText(this T)(int fromLine, int fromChar, int toLine, int toChar)
	{
		this._tk.eval("%s delete %s.%s %s.%s", this.id, fromLine, fromChar, toLine, toChar);

		return cast(T) this;
	}

	/**
	 * Delete all content from the widget.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto clear(this T)()
	{
		this._tk.eval("%s delete 0.0 end", this.id);

		return cast(T) this;
	}

	/**
	 * Embed a widget into the text.
	 *
	 * Params:
	 *     line = The line at which to insert the text. Indexes start at 1.
	 *     character = The character at which to insert the text. Indexes start at 0.
	 *     widget = The widget to embed.
	 *     padding = The amount of padding around the widget.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto embedWidget(this T)(int line, int character, Widget widget, int padding = 0)
	{
		this._tk.eval("%s window create %s.%s -window %s -align center -padx %s -pady %s", this.id, line, character, widget.id, padding, padding);

		return cast(T) this;
	}

	/**
	 * Embed an image into the text.
	 *
	 * Params:
	 *     line = The line at which to insert the text. Indexes start at 1.
	 *     character = The character at which to insert the text. Indexes start at 0.
	 *     image = The image to embed.
	 *     padding = The amount of padding around the widget.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto embedImage(this T)(int line, int character, Image image, int padding = 0)
	{
		this._tk.eval("%s image create %s.%s -image %s -align center -padx %s -pady %s", this.id, line, character, image.id, padding, padding);

		return cast(T) this;
	}

	/**
	 * Undo the last edit to the widget. This only applied to the widget if 
	 * undo is enabled.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto undo(this T)()
	{
		this._tk.eval("%s edit undo", this.id);

		return cast(T) this;
	}

	/**
	 * Redo the last edit to the widget. This only applied to the widget if 
	 * undo is enabled.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto redo(this T)()
	{
		this._tk.eval("%s edit redo", this.id);

		return cast(T) this;
	}

	/**
	 * Clear all undo's. This only applied to the widget if 
	 * undo is enabled.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto resetUndo(this T)()
	{
		this._tk.eval("%s edit reset", this.id);

		return cast(T) this;
	}

	/**
	 * See a particular text index. The text widget automatically scrolls to 
	 * see the passed indexes.
	 *
	 * Params:
	 *     line = The line to see. Indexes start at 1.
	 *     character = The character to see. Indexes start at 0.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto seeText(this T)(int line, int character = 0)
	{
		this._tk.eval("%s see %s.%s", this.id, line, character);

		return cast(T) this;
	}

	/**
	 * Cut the selected text to the clipboard.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto cutText(this T)()
	{
		this._tk.eval("tk_textCut %s", this.id);

		return cast(T) this;
	}

	/**
	 * Copy the selected text to the clipboard.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto copyText(this T)()
	{
		this._tk.eval("tk_textCopy %s", this.id);

		return cast(T) this;
	}

	/**
	 * Paste the selected text from the clipboard at the cursor position.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto pasteText(this T)()
	{
		this._tk.eval("tk_textPaste %s", this.id);

		return cast(T) this;
	}

	/**
	 * Mixin common commands.
	 */
	mixin Border;
	mixin Height;
	mixin Relief;
	mixin Width;
	mixin XScrollCommand!(Text);
	mixin XView;
	mixin YScrollCommand!(Text);
	mixin YView;
}
