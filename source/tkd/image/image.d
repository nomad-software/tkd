/**
 * Image module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.image.image;

/**
 * Imports.
 */
import tkd.element.element;

/**
 * The image base class.
 */
class Image : Element
{
	/**
	 * Construct the image.
	 *
	 * Params:
	 *     filename = The filename of the image to load.
	 */
	public this(string filename)
	{
		super();
		this._hash      = this.generateHash(filename);
		this._elementId = "image";

		this._tk.eval("image create photo %s -format png -file %s", this.id, filename);
	}

}
