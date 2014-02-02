/**
 * Image module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.image.image;

/**
 * Imports.
 */
import tkd.element.element;

/**
 * The image base class.
 */
abstract class Image : Element
{
	/**
	 * Construct the image.
	 *
	 * Params:
	 *     filename = The filename of the image to load.
	 */
	protected this(string filename)
	{
		super();
		this._hash      = this.generateHash(filename);
		this._elementId = "image";
	}

}
