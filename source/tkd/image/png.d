/**
 * Image module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.image.png;

/**
 * Imports.
 */
import tkd.image.image;
import tkd.image.imageformat;

/**
 * Helper class to quickly create an embedded Png format image.
 *
 * Params:
 *     filename = The filename of the image to embed.
 *
 * See_Also:
 *     $(LINK2 ../image/image.html, tkd.image.image) $(BR)
 */
class Png(string filename) : Image
{
	/**
	 * Construct the image.
	 */
	public this()
	{
		super();

		this.setFormat(ImageFormat.png);
		this.embedDataFromFile!(filename);
	}

	/**
	 * Set the image alpha.
	 *
	 * Params:
	 *     alpha = The alpha of the image.
	 */
	public void setAlpha(float alpha)
	{
		if (alpha < 0f || alpha > 1.0f)
		{
			alpha = 1.0f;
		}

		this._tk.eval("%s configure -format \"png -alpha %s\"", this.id, alpha);
	}
}
