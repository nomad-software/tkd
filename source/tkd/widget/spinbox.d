/**
 * Widget module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.spinbox;

/**
 * Imports.
 */
import std.string;
import tkd.element.uielement;
import tkd.widget.common.boundingbox;
import tkd.widget.common.command;
import tkd.widget.common.cursor;
import tkd.widget.common.data;
import tkd.widget.common.delete_;
import tkd.widget.common.exportselection;
import tkd.widget.common.index;
import tkd.widget.common.insert;
import tkd.widget.common.justify;
import tkd.widget.common.range;
import tkd.widget.common.selection;
import tkd.widget.common.show;
import tkd.widget.common.value;
import tkd.widget.common.width;
import tkd.widget.common.xscrollcommand;
import tkd.widget.common.xview;
import tkd.widget.widget;

/**
 * A spinbox widget is an entry widget with built-in up and down buttons that 
 * are used to either modify a numeric value or to select among a set of 
 * values. The widget implements all the features of the entry widget.
 *
 * If a list of string values are set to be controlled by this widget it will 
 * override any numeric range or step set. The widget will instead use the 
 * values specified beginning with the first value.
 *
 * Example:
 * ---
 * auto spinBox = new SpinBox()
 * 	.setCommand(delegate(CommandArgs arg){ ... })
 * 	.setFromValue(0.0)
 * 	.setToValue(100.0)
 * 	.setStep(0.5)
 * 	.setValue(0.0)
 * 	.pack();
 * ---
 *
 * Common_Commands:
 *     These are injected common commands that can also be used with this widget.
 *     $(P
 *         $(LINK2 ./common/boundingbox.html, BoundingBox) $(BR)
 *         $(LINK2 ./common/command.html, Command) $(BR)
 *         $(LINK2 ./common/cursor.html, Cursor) $(BR)
 *         $(LINK2 ./common/data.html, Data) $(BR)
 *         $(LINK2 ./common/delete_.html, Delete) $(BR)
 *         $(LINK2 ./common/exportselection.html, Exportselection) $(BR)
 *         $(LINK2 ./common/index.html, Index) $(BR)
 *         $(LINK2 ./common/insert.html, Insert) $(BR)
 *         $(LINK2 ./common/justify.html, Justify) $(BR)
 *         $(LINK2 ./common/range.html, Range) $(BR)
 *         $(LINK2 ./common/selection.html, Selection) $(BR)
 *         $(LINK2 ./common/show.html, Show) $(BR)
 *         $(LINK2 ./common/value.html, Value) $(BR)
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
 *         &lt;&lt;Decrement&gt;&gt;,
 *         &lt;&lt;Increment&gt;&gt;,
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
 *         &lt;Control-Button-1&gt;,
 *         &lt;Control-Key&gt;,
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
 *         &lt;Control-Key-space&gt;,
 *         &lt;Control-Key-t&gt;,
 *         &lt;Control-Shift-Key-Left&gt;,
 *         &lt;Control-Shift-Key-Right&gt;,
 *         &lt;Control-Shift-Key-space&gt;,
 *         &lt;Double-Button-1&gt;,
 *         &lt;Double-Shift-Button-1&gt;,
 *         &lt;Key&gt;,
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
 *         &lt;Key-Return&gt;,
 *         &lt;Key-Right&gt;,
 *         &lt;Key-Select&gt;,
 *         &lt;Key-Tab&gt;,
 *         &lt;Key-Up&gt;,
 *         &lt;Meta-Key&gt;,
 *         &lt;Meta-Key-BackSpace&gt;,
 *         &lt;Meta-Key-Delete&gt;,
 *         &lt;Meta-Key-b&gt;,
 *         &lt;Meta-Key-d&gt;,
 *         &lt;Meta-Key-f&gt;,
 *         &lt;Shift-Button-1&gt;,
 *         &lt;Shift-Key-End&gt;,
 *         &lt;Shift-Key-Home&gt;,
 *         &lt;Shift-Key-Left&gt;,
 *         &lt;Shift-Key-Right&gt;,
 *         &lt;Shift-Key-Select&gt;,
 *         &lt;Triple-Button-1&gt;,
 *         &lt;Triple-Shift-Button-1&gt;,
 *     )
 *
 * See_Also:
 *     $(LINK2 ./widget.html, tkd.widget.widget)
 */
class SpinBox : Widget, IXScrollable!(SpinBox)
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
		this._elementId = "spinbox";
		this._valueVariable = format("variable-%s", this.generateHash(this.id));

		this._tk.eval("ttk::spinbox %s -textvariable %s", this.id, this._valueVariable);

		this.setFromValue(int.min);
		this.setToValue(int.max);
		this.setValue("0");
	}

	/**
	 * For widgets using a numeric range, this method sets the step value of 
	 * each increment or decrement.
	 *
	 * Params:
	 *     stepValue = The step value to increment and decrement by.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto setStep(this T)(double stepValue)
	{
		assert(stepValue > 0, "Step value should be greater than zero.");

		this._tk.eval("%s configure -increment %s", this.id, stepValue);

		return cast(T) this;
	}

	/**
	 * Set whether the values wrap when the limit is reached during increment 
	 * or decrement.
	 *
	 * Params:
	 *     wrapValue = Value specifing whether the value wraps.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto setWrap(this T)(bool wrapValue)
	{
		this._tk.eval("%s configure -wrap %s", this.id, wrapValue);

		return cast(T) this;
	}

	/**
	 * Specifies an alternate format to use when using a numerical range. This 
	 * must be a format specifier of the form '%5.2f', as it will format a 
	 * floating-point number.
	 *
	 * Params:
	 *     digitsBefore = The amount of digits to show before a decimal point.
	 *     digitsAfter = The amount of digits to show after a decimal point.
	 *
	 * Returns:
	 *     This widget to aid method chaining.
	 */
	public auto setNumericFormat(this T)(int digitsBefore, int digitsAfter)
	{
		this._tk.eval("%s configure -format %%%s.%sf", this.id, digitsBefore, digitsAfter);

		return cast(T) this;
	}

	/**
	 * Mixin common commands.
	 */
	mixin BoundingBox;
	mixin Command;
	mixin Cursor;
	mixin Data;
	mixin Delete_;
	mixin ExportSelection;
	mixin Index;
	mixin Insert;
	mixin Justify;
	mixin Range;
	mixin Selection;
	mixin Show;
	mixin Value!(this._valueVariable, string);
	mixin Width;
	mixin XScrollCommand!(SpinBox);
	mixin XView;
}
