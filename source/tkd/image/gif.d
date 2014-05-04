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
	 *     fileName = The file name of the image to load.
	 *     embed = Whether to embed image data or not.
	 *
	 * Bugs:
	 *     Embedding images over 20x20 pixels can cause issues with event and 
	 *     command callbacks. It seems it can corrupt the client data passed 
	 *     internally to the command callback handler (element.d). This is 
	 *     incredibly fustrating and hard to track down. Any help is 
	 *     appreciated due to the fact this makes embedding images into 
	 *     applications very difficult.
	 */
	public this(string fileName, bool embed = false)
	{
		super();

		this.setFormat(ImageFormat.gif);

		if (embed)
		{
			this.setData(Base64.encode(cast(ubyte[])read(fileName)));
		}
		else
		{
			this.setFile(fileName);
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
