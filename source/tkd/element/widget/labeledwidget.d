/**
 * Labeled widget module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.element.widget.labeledwidget;

/**
 * Imports.
 */
import std.string;
import tkd.element.element;
import tkd.element.widget.widget;

/**
 * The labeled widget base class.
 */
abstract class LabeledWidget : Widget
{
	/**
	 * The name of the text variable that contains the widget's text.
	 */
	protected string _textVariable;

	/**
	 * Construct the widget.
	 *
	 * Params:
	 *     parent = An optional parent of this widget.
	 *     text = The label text.
	 */
	public this(Element parent = null, string text = null)
	{
		super(parent);

		this._elementId    = "labeledwidget";
		this._textVariable = format("variable-%s", this.generateHash(this.id));

		this.setText(text);
	}

	/**
	 * Clean up.
	 */
	protected ~this()
	{
		this._tk.deleteVariable(this._textVariable);
	}

	/**
	 * Set the label text.
	 *
	 * Params:
	 *     text = The label text.
	 */
	public void setText(string text)
	{
		this._tk.setVariable(this._textVariable, text);
	}

	/**
	 * Get the label text.
	 *
	 * Returns:
	 *     A string containing the label text.
	 */
	public string getText()
	{
		return this._tk.getVariable(this._textVariable);
	}

}
