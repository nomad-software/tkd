/**
 * Widget module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.entry;

/**
 * Imports.
 */
import std.conv;
import std.string;
import tkd.element.uielement;
import tkd.widget.common.boundingbox;
import tkd.widget.common.cursor;
import tkd.widget.common.delete_;
import tkd.widget.common.exportselection;
import tkd.widget.common.index;
import tkd.widget.common.insert;
import tkd.widget.common.justify;
import tkd.widget.common.selection;
import tkd.widget.common.show;
import tkd.widget.common.value;
import tkd.widget.common.width;
import tkd.widget.common.xscrollcommand;
import tkd.widget.common.xview;
import tkd.widget.widget;

/**
 * An entry widget displays a one-line text string and allows that string to be 
 * edited by the user. Entry widgets support horizontal scrolling.
 *
 * Common_Commands:
 *     These are injected common commands that can also be used with this widget.
 *     $(P
 *         $(LINK2 ./common/boundingbox.html, BoundingBox) $(BR)
 *         $(LINK2 ./common/cursor.html, Cursor) $(BR)
 *         $(LINK2 ./common/delete_.html, Delete) $(BR)
 *         $(LINK2 ./common/exportselection.html, Exportselection) $(BR)
 *         $(LINK2 ./common/index.html, Index) $(BR)
 *         $(LINK2 ./common/insert.html, Insert) $(BR)
 *         $(LINK2 ./common/justify.html, Justify) $(BR)
 *         $(LINK2 ./common/selection.html, Selection) $(BR)
 *         $(LINK2 ./common/show.html, Show) $(BR)
 *         $(LINK2 ./common/value.html, Values) $(BR)
 *         $(LINK2 ./common/width.html, Width) $(BR)
 *         $(LINK2 ./common/xscrollcommand.html, XScrollCommand) $(BR)
 *         $(LINK2 ./common/xview.html, XView) $(BR)
 *     )
 *
 * Additional_Events:
 *     Additional events that can also be bound to using the $(LINK2 ../element/uielement.html#UiElement.bind, bind) method.
 *     $(P
 *         &lt;&lt;Clear&gt;&gt;,
 *         &lt;&lt;Copy&gt;&gt;,
 *         &lt;&lt;Cut&gt;&gt;,
 *         &lt;&lt;Paste&gt;&gt;,
 *         &lt;&lt;PasteSelection&gt;&gt;,
 *         &lt;&lt;PrevWindow&gt;&gt;,
 *         &lt;&lt;TraverseIn&gt;&gt;,
 *         &lt;Alt-Key&gt;,
 *         &lt;B1-Enter&gt;,
 *         &lt;B1-Leave&gt;,
 *         &lt;B1-Motion&gt;,
 *         &lt;B2-Motion&gt;,
 *         &lt;Button-1&gt;,
 *         &lt;Button-2&gt;,
 *         &lt;ButtonRelease-1&gt;,
 *         &lt;ButtonRelease-2&gt;,
 *         &lt;Control-Button-1&gt;,
 *         &lt;Control-Key-Left&gt;,
 *         &lt;Control-Key-Right&gt;,
 *         &lt;Control-Key-a&gt;,
 *         &lt;Control-Key-b&gt;,
 *         &lt;Control-Key-backslash&gt;,
 *         &lt;Control-Key-d&gt;,
 *         &lt;Control-Key-e&gt;,
 *         &lt;Control-Key-f&gt;,
 *         &lt;Control-Key-h&gt;,
 *         &lt;Control-Key-k&gt;,
 *         &lt;Control-Key-slash&gt;,
 *         &lt;Control-Key&gt;,
 *         &lt;Control-Shift-Key-Left&gt;,
 *         &lt;Control-Shift-Key-Right&gt;,
 *         &lt;Double-Button-1&gt;,
 *         &lt;Key-BackSpace&gt;,
 *         &lt;Key-Delete&gt;,
 *         &lt;Key-Down&gt;,
 *         &lt;Key-End&gt;,
 *         &lt;Key-Escape&gt;,
 *         &lt;Key-F10&gt;,
 *         &lt;Key-Home&gt;,
 *         &lt;Key-KP_Enter&gt;,
 *         &lt;Key-Left&gt;,
 *         &lt;Key-Return&gt;,
 *         &lt;Key-Right&gt;,
 *         &lt;Key-Tab&gt;,
 *         &lt;Key-Up&gt;,
 *         &lt;Key&gt;,
 *         &lt;Meta-Key&gt;,
 *         &lt;Shift-Button-1&gt;,
 *         &lt;Shift-Key-End&gt;,
 *         &lt;Shift-Key-Home&gt;,
 *         &lt;Shift-Key-Left&gt;,
 *         &lt;Shift-Key-Right&gt;,
 *         &lt;Triple-Button-1&gt;,
 *     )
 *
 * States:
 *     In the disabled state, the entry cannot be edited and the text cannot be 
 *     selected. In the readonly state, no insert cursor is displayed and the 
 *     entry cannot be edited. The disabled state is the same as readonly, and 
 *     in addition text cannot be selected. Typically, the text is "grayed-out" 
 *     in the disabled state, and a different background is used in the 
 *     readonly state.
 *
 * See_Also:
 *     $(LINK2 ./widget.html, tkd.widget.widget)
 */
class Entry : Widget, IXScrollable!(Entry)
{
	/**
	 * The name of the variable that contains the widget's value.
	 */
	private string _valueVariable;

	/**
	 * Construct the widget.
	 *
	 * Params:
	 *     parent = The parent of this widget.
	 *
	 * See_Also:
	 *     $(LINK2 ../element/uielement.html, tkd.element.uielement) $(BR)
	 */
	this(UiElement parent = null)
	{
		super(parent);
		this._elementId = "entry";
		this._valueVariable = format("variable-%s", this.generateHash(this.id));

		this._tk.eval("ttk::entry %s -textvariable %s", this.id, this._valueVariable);
	}

	/**
	 * Mixin common commands.
	 */
	mixin BoundingBox;
	mixin Cursor;
	mixin Delete_;
	mixin ExportSelection;
	mixin Index;
	mixin Insert;
	mixin Justify;
	mixin Selection;
	mixin Show;
	mixin Value!(this._valueVariable, string);
	mixin Width;
	mixin XScrollCommand!(Entry);
	mixin XView;
}
