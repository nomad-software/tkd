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
import std.base64;
import std.file;
import tkd.image.image;
import tkd.image.imageformat;

/**
 * Helper class to quickly create a Png format image.
 *
 * See_Also:
 *     $(LINK2 ../image/image.html, tkd.image.image) $(BR)
 */
class Png : Image
{
	/**
	 * Construct the image.
	 *
	 * Params:
	 *     file = The file name of the image to load.
	 */
	public this(string file)
	{
		super();

		this.setFormat(ImageFormat.png);

		if (file)
		{
			this.setFile(file);
		}
	}

	/**
	 * Set the image alpha.
	 *
	 * Params:
	 *     alpha = The alpha of the image.
	 *
	 * Returns:
	 *     This image to aid method chaining.
	 */
	public auto setAlpha(this T)(double alpha)
	{
		if (alpha < 0f || alpha > 1.0f)
		{
			alpha = 1.0f;
		}

		this._tk.eval("%s configure -format {png -alpha %s}", this.id, alpha);

		return cast(T) this;
	}
}

/**
 * Helper class to quickly create an embedded Png format image.
 *
 * Params:
 *     file = The file name of the image to embed.
 *
 * See_Also:
 *     $(LINK2 ../image/image.html, tkd.image.image) $(BR)
 */
class EmbeddedPng(string file) : Png
{
	/**
	 * Construct the image.
	 */
	public this()
	{
		super(null);

		this.embedBase64Data!(file);
	}
}
