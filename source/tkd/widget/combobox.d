/**
 * Widget module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.combobox;

/**
 * Imports.
 */
import std.conv;
import tkd.element.uielement;
import tkd.widget.common.boundingbox;
import tkd.widget.common.cursor;
import tkd.widget.common.delete_;
import tkd.widget.common.exportselection;
import tkd.widget.common.height;
import tkd.widget.common.index;
import tkd.widget.common.insert;
import tkd.widget.common.justify;
import tkd.widget.common.postcommand;
import tkd.widget.common.selection;
import tkd.widget.common.value;
import tkd.widget.common.values;
import tkd.widget.common.width;
import tkd.widget.common.xscrollcommand;
import tkd.widget.common.xview;
import tkd.widget.widget;

/**
 * Class representing a combo box widget.
 *
 * This widget has two types of values that can be set. First, a list of values 
 * can be set to populate the drop-down list which can then be selected via a 
 * mouse. Second, the value can be set independently and in addition to the 
 * value list. See the below widget specific and common commands for an 
 * overview of how this works.
 *
 * Common_Commands:
 *     These are injected common commands that can also be used with this widget.
 *     $(P
 *         $(LINK2 ./common/boundingbox.html, BoundingBox) $(BR)
 *         $(LINK2 ./common/cursor.html, Cursor) $(BR)
 *         $(LINK2 ./common/delete_.html, Delete) $(BR)
 *         $(LINK2 ./common/exportselection.html, Exportselection) $(BR)
 *         $(LINK2 ./common/height.html, Height) $(BR)
 *         $(LINK2 ./common/index.html, Index) $(BR)
 *         $(LINK2 ./common/insert.html, Insert) $(BR)
 *         $(LINK2 ./common/justify.html, Justify) $(BR)
 *         $(LINK2 ./common/postcommand.html, PostCommand) $(BR)
 *         $(LINK2 ./common/selection.html, Selection) $(BR)
 *         $(LINK2 ./common/value.html, Values) $(BR)
 *         $(LINK2 ./common/values.html, Values) $(BR)
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
 *         &lt;Button-4&gt;,
 *         &lt;Button-5&gt;,
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
 *         &lt;Motion&gt;,
 *         &lt;Shift-Button-1&gt;,
 *         &lt;Shift-Key-End&gt;,
 *         &lt;Shift-Key-Home&gt;,
 *         &lt;Shift-Key-Left&gt;,
 *         &lt;Shift-Key-Right&gt;,
 *         &lt;Triple-Button-1&gt;,
 *     )
 *
 * See_Also:
 *     $(LINK2 ./widget.html, tkd.widget.widget)
 */
class ComboBox : Widget, IXScrollable
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
		this._elementId = "combobox";
		this._valueVariable = format("variable-%s", this.generateHash(this.id));

		this._tk.eval("ttk::combobox %s -textvariable %s", this.id, this._valueVariable);

		this.setState(["readonly"]);

		this.bind("<<ComboboxSelected>>", delegate(UiElement sender, BindArgs args){
			this.deselectText();
		});
	}

	/**
	 * Get the index of the selected value from the current widget's list values.
	 *
	 * Returns:
	 *     The index of the selected list value.
	 *     Indexes start at 0 and -1 is returned if the current value does not appear in the list.
	 */
	public int getSelected()
	{
		this._tk.eval("%s current", this.id);
		return this._tk.getResult().to!(int);
	}

	/**
	 * Select the value at a particular index in the value list.
	 *
	 * Params:
	 *     index = The index of the value to select.
	 */
	public void select(int index)
	{
		this._tk.eval("%s current %s", this.id, index);
	}

	/**
	 * Mixin common commands.
	 */
	mixin BoundingBox;
	mixin Cursor;
	mixin Delete_;
	mixin ExportSelection;
	mixin Height;
	mixin Index;
	mixin Insert;
	mixin Justify;
	mixin PostCommand;
	mixin Selection;
	mixin Value!(this._valueVariable);
	mixin Values;
	mixin Width;
	mixin XScrollCommand;
	mixin XView;
}
