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
import std.base64;
import std.file;
import tkd.image.image;
import tkd.image.imageformat;

/**
 * Helper class to quickly create an embedded Gif format image.
 *
 * See_Also:
 *     $(LINK2 ../image/image.html, tkd.image.image) $(BR)
 */
class Gif : Image
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

		this.setFormat(ImageFormat.gif);

		if (file)
		{
			this.setFile(file);
		}
	}

	/**
	 * Select the index if a multi-indexed gif.
	 * If you select an idex which doesn't exist in the image an error will occur.
	 *
	 * Params:
	 *     index = The index to select.
	 *
	 * Returns:
	 *     This image to aid method chaining.
	 */
	public auto setIndex(this T)(int index)
	{
		this._tk.eval("%s configure -format {gif -index %s}", this.id, index);

		return cast(T) this;
	}
}

/**
 * Helper class to quickly create an embedded Gif format image.
 *
 * Params:
 *     file = The file name of the image to embed.
 *
 * See_Also:
 *     $(LINK2 ../image/image.html, tkd.image.image) $(BR)
 */
class EmbeddedGif(string file) : Gif
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
