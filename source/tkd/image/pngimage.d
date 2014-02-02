/**
 * Image module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.image.pngimage;

/**
 * Imports.
 */
import tkd.image.image;

/**
 * The png image class.
 */
class PngImage : Image
{
	/**
	 * Construct the image.
	 *
	 * Params:
	 *     filename = The filename of the image to load.
	 */
	public this(string filename)
	{
		super(filename);
		this._elementId = "pngimage";
		this._tk.eval("image create photo %s -format png -file %s", this.id, filename);
	}

}
