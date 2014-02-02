/**
 * Image module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.image.gifimage;

/**
 * Imports.
 */
import tkd.image.image;

/**
 * The gif image class.
 */
class GifImage : Image
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
		this._elementId = "gifimage";
		this._tk.eval("image create photo %s -format gif -file %s", this.id, filename);
	}

}
