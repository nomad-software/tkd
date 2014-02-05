/**
 * Image module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.image.gif;

/**
 * Imports.
 */
import tkd.image.image;
import tkd.image.imageformat;

/**
 * Helper class to quickly create an embedded Gif format image.
 *
 * Params:
 *     filename = The filename of the image to embed.
 */
class Gif(string filename) : Image
{
	/**
	 * Construct the image.
	 */
	public this()
	{
		super();

		this.setFormat(ImageFormat.gif);
		this.embedDataFromFile!(filename);
	}

	/**
	 * Select the index if a multi-indexed gif.
	 *
	 * Params:
	 *     index = The index to select.
	 */
	public void setIndex(int index)
	{
		this._tk.eval("%s configure -format \"gif -index %s\"", this.id, index);
	}
}
