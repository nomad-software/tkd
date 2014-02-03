/**
 * Widget module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.textwidget;

/**
 * Imports.
 */
import std.string;
import tkd.element.uielement;
import tkd.image.image;
import tkd.image.imageposition;
import tkd.widget.widget;

/**
 * The text widget base class.
 */
abstract class TextWidget : Widget
{
	/**
	 * The name of the text variable that contains the widget's text.
	 */
	protected string _textVariable;

	/**
	 * The image of this widget.
	 */
	protected Image _image;

	/**
	 * Construct the widget.
	 *
	 * Params:
	 *     parent = An optional parent of this widget.
	 *     text = The widget text.
	 */
	public this(UiElement parent = null, string text = null)
	{
		super(parent);

		this._elementId    = "textwidget";
		this._textVariable = format("variable-%s", this.generateHash(this.id));

		this.setText(text);
	}

	/**
	 * Set the widget text.
	 *
	 * Params:
	 *     text = The widget text.
	 */
	public void setText(string text)
	{
		this._tk.setVariable(this._textVariable, text);
	}

	/**
	 * Get the widget text.
	 *
	 * Returns:
	 *     A string containing the widget text.
	 */
	public string getText()
	{
		return this._tk.getVariable(this._textVariable);
	}

	/**
	 * Underline one of the characters in the widget text.
	 *
	 * Params:
	 *     index = The index of the character to underline.
	 */
	public void underlineChar(int index)
	{
		this._tk.eval("%s configure -underline %s", this.id, index);
	}

	/**
	 * Add an image to this widget.
	 */
	public void addImage(Image image, string imagePosition = ImagePosition.image)
	{
		this._image = image;

		this._tk.eval("%s configure -image %s -compound %s", this.id, this._image.id, imagePosition);
	}

}
