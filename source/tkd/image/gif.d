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
 *
 * See_Also:
 *     $(LINK2 ../image/image.html, tkd.image.image) $(BR)
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
	 * If you select an idex which doesn't exist in the image an error will occur.
	 *
	 * Params:
	 *     index = The index to select.
	 */
	public void setIndex(int index)
	{
		this._tk.eval("%s configure -format \"gif -index %s\"", this.id, index);
	}
}
