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
import std.base64;
import tkd.image.image;
import tkd.image.imageformat;

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
		super();

		this.setFormat(ImageFormat.png);

		// auto data = cast(ubyte[])std.file.read(filename);
		// this.setData(Base64.encode(data));

		this.setFile(filename);
	}

}
