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
import tkd.image.imageformat;

/**
 * The image base class.
 */
class Image : Element
{
	/**
	 * Construct the image.
	 */
	public this()
	{
		super();
		this._elementId = "image";

		this._tk.eval("image create photo %s", this.id);
	}

	/**
	 * Clears the image of all pixel data and effectively makes it transparent.
	 */
	public void blank()
	{
		this._tk.eval("%s blank", this.id);
	}

	/**
	 * Set the image data.
	 * This should be base64 encoded binary data.
	 *
	 * Params:
	 *     data = Base64 encoded data.
	 */
	public void setData(string data)
	{
		this._tk.eval("%s configure -data %s", this.id, data);
	}

	/**
	 * Get the image data.
	 *
	 * Returns:
	 *     Base64 encoded image data.
	 */
	public string getData()
	{
		this._tk.eval("%s cget -data", this.id);
		return this._tk.getResult();
	}

	/**
	 * Set the image format.
	 * Once set the image only accepts files or data in this format.
	 *
	 * Params:
	 *     format = A valid image format.
	 *
	 * See_Also:
	 *     $(LINK2 imageformat.html, tkd.image.imageformat) for supported formats.
	 */
	public void setFormat(string format)
	{
		this._tk.eval("%s configure -format %s", this.id, format);
	}

	/**
	 * Get the image format.
	 *
	 * Returns:
	 *     The image format.
	 */
	public string getFormat()
	{
		this._tk.eval("%s cget -format", this.id);
		return this._tk.getResult();
	}

	/**
	 * Set the file to read the image data from.
	 *
	 * Params:
	 *     file = The file to read the image data from.
	 */
	public void setFile(string file)
	{
		this._tk.eval("%s configure -file %s", this.id, file);
	}

	/**
	 * Get the image file.
	 *
	 * Returns:
	 *     The file that was loaded for this image.
	 */
	public string getFile()
	{
		this._tk.eval("%s cget -file", this.id);
		return this._tk.getResult();
	}

	/**
	 * Set the image gamma.
	 *
	 * Params:
	 *     gamma = The destination gamma.
	 */
	public void setGamma(string gamma)
	{
		this._tk.eval("%s configure -gamma %s", this.id, gamma);
	}

	/**
	 * Get the current image gamma.
	 *
	 * Returns:
	 *     A string containing the image gamma setting.
	 */
	public string getGamma()
	{
		this._tk.eval("%s cget -gamma", this.id);
		return this._tk.getResult();
	}

	/**
	 * Set the image height.
	 *
	 * Params:
	 *     height = The height to crop the image to.
	 */
	public void setHeight(int height)
	{
		this._tk.eval("%s configure -height %s", this.id, height);
	}

	/**
	 * Get the current cropped image height.
	 *
	 * Returns:
	 *     The current cropped image height. Returns 0 if no cropping is taking place.
	 */
	public string getHeight()
	{
		this._tk.eval("%s cget -height", this.id);
		return this._tk.getResult();
	}

	/**
	 * Set the image palette. This setting set how many levels of color/gray are used.
	 *
	 * Sample_Palettes:
	 *     $(UL
	 *         $(LI "16" = 16 levels of gray)
	 *         $(LI "16/16/16" = 16 levels of RGB)
	 *     )
	 *
	 * Params:
	 *     palette = A string describing the palette to use.
	 */
	public void setPalette(string palette)
	{
		this._tk.eval("%s configure -palette %s", this.id, palette);
	}

	/**
	 * Get the current palette.
	 *
	 * Returns:
	 *     A string describing the palette.
	 */
	public string getPalette()
	{
		this._tk.eval("%s cget -palette", this.id);
		return this._tk.getResult();
	}

	/**
	 * Set the image width.
	 *
	 * Params:
	 *     width = The width to crop the image to.
	 */
	public void setWidth(int width)
	{
		this._tk.eval("%s configure -width %s", this.id, width);
	}

	/**
	 * Get the current cropped image height.
	 *
	 * Returns:
	 *     The current cropped image height. Returns 0 if no cropping is taking place.
	 */
	public string getWidth()
	{
		this._tk.eval("%s cget -width", this.id);
		return this._tk.getResult();
	}
}
