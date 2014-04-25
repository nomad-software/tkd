/**
 * Widget module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.scale;

/**
 * Imports.
 */
import std.string;
import tkd.element.uielement;
import tkd.widget.common.command;
import tkd.widget.common.length;
import tkd.widget.common.range;
import tkd.widget.common.value;
import tkd.widget.orientation;
import tkd.widget.widget;

/**
 * A scale widget is typically used to control the numeric value that varies 
 * uniformly over some range. A scale displays a slider that can be moved along 
 * over a trough, with the relative position of the slider over the trough 
 * indicating the value.
 *
 * Example:
 * ---
 * auto scale = new Scale()
 * 	.setCommand(delegate(CommandArgs arg){ ... })
 * 	.setFromValue(0.0)
 * 	.setToValue(100.0)
 * 	.pack();
 * ---
 *
 * Common_Commands:
 *     These are injected common commands that can also be used with this widget.
 *     $(P
 *         $(LINK2 ./common/command.html, Command) $(BR)
 *         $(LINK2 ./common/length.html, Length) $(BR)
 *         $(LINK2 ./common/range.html, Range) $(BR)
 *         $(LINK2 ./common/value.html, Value) $(BR)
 *     )
 *
 * Additional_Events:
 *     Additional events that can also be bound to using the $(LINK2 ../element/uielement.html#UiElement.bind, bind) method.
 *     $(P
 *         &lt;&lt;PrevWindow&gt;&gt;,
 *         &lt;Alt-Key&gt;,
 *         &lt;B1-Motion&gt;,
 *         &lt;B2-Motion&gt;,
 *         &lt;B3-Motion&gt;,
 *         &lt;Button-1&gt;,
 *         &lt;Button-2&gt;,
 *         &lt;Button-3&gt;,
 *         &lt;ButtonRelease-1&gt;,
 *         &lt;ButtonRelease-2&gt;,
 *         &lt;ButtonRelease-3&gt;,
 *         &lt;Control-Key-Down&gt;,
 *         &lt;Control-Key-Left&gt;,
 *         &lt;Control-Key-Right&gt;,
 *         &lt;Control-Key-Up&gt;,
 *         &lt;Key-Down&gt;,
 *         &lt;Key-End&gt;,
 *         &lt;Key-F10&gt;,
 *         &lt;Key-Home&gt;,
 *         &lt;Key-Left&gt;,
 *         &lt;Key-Right&gt;,
 *         &lt;Key-Tab&gt;,
 *         &lt;Key-Up&gt;,
 *     )
 *
 * See_Also:
 *     $(LINK2 ./widget.html, tkd.widget.widget)
 */
class Scale : Widget
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
	 *     orientation = The orientation of the widget.
	 *
	 * See_Also:
	 *     $(LINK2 ../element/uielement.html, tkd.element.UiElement) $(BR)
	 *     $(LINK2 ./orientation.html, tkd.widget.orientation) for orientations.
	 */
	public this(UiElement parent, string orientation = Orientation.horizontal)
	{
		super(parent);
		this._elementId     = "scale";
		this._valueVariable = format("variable-%s", this.generateHash(this.id));

		this._tk.eval("ttk::scale %s -orient %s -variable %s", this.id, orientation, this._valueVariable);
	}

	/**
	 * Construct the widget.
	 *
	 * Params:
	 *     orientation = The orientation of the widget.
	 *
	 * See_Also:
	 *     $(LINK2 ./orientation.html, tkd.widget.orientation) for orientations.
	 */
	public this(string orientation = Orientation.horizontal)
	{
		this(null, orientation);
	}

	/**
	 * Mixin common commands.
	 */
	mixin Command;
	mixin Length;
	mixin Range;
	mixin Value!(this._valueVariable, double);
}
