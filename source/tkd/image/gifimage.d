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
import tkd.image.imageformat;

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
		super();

		this.setFormat(ImageFormat.gif);

		// auto data = cast(ubyte[])std.file.read(filename);
		// this.setData(Base64.encode(data));

		this.setFile(filename);
	}

}
