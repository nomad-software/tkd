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
	 * This method embeds the image as a base64 encoded string into the 
	 * application at compile-time. The path to the image must be passed to the 
	 * compiler using the -J switch.
	 *
	 * Params:
	 *     filename = The filename to read the data from.
	 *
	 * Returns:
	 *     This image to aid method chaining.
	 */
	protected auto embedBase64Data(string filename, this T)()
	{
		this.setData(base64Encode!(filename));

		return cast(T) this;
	}

	/**
	 * Clears the image of all pixel data and effectively makes it transparent.
	 *
	 * Returns:
	 *     This image to aid method chaining.
	 */
	public auto blank(this T)()
	{
		this._tk.eval("%s blank", this.id);

		return cast(T) this;
	}

	/**
	 * Specifies the contents of the image as a string. The string should 
	 * contain binary data or, for some formats, base64-encoded data (this is 
	 * currently guaranteed to be supported for PNG and GIF images). A set 
	 * file takes precedence over the setting of data.
	 *
	 * Params:
	 *     data = The image data.
	 *
	 * Returns:
	 *     This image to aid method chaining.
	 */
	public auto setData(this T)(string data)
	{
		this._tk.eval("%s configure -data {%s}", this.id, data);

		return cast(T) this;
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
		return this._tk.getResult!(string);
	}

	/**
	 * Set the image format.
	 * Once set the image only accepts files or data in this format.
	 *
	 * Params:
	 *     format = A valid image format.
	 *
	 * Returns:
	 *     This image to aid method chaining.
	 *
	 * See_Also:
	 *     $(LINK2 ./imageformat.html, tkd.image.imageformat) for supported formats.
	 */
	public auto setFormat(this T)(string format)
	{
		this._tk.eval("%s configure -format {%s}", this.id, format);

		return cast(T) this;
	}

	/**
	 * Get the image format.
	 *
	 * Returns:
	 *     The image format.
	 *
	 * See_Also:
	 *     $(LINK2 ./imageformat.html, tkd.image.imageformat) for returned formats.
	 */
	public string getFormat()
	{
		this._tk.eval("%s cget -format", this.id);
		return this._tk.getResult!(string);
	}

	/**
	 * Set the image file.
	 *
	 * Params:
	 *     file = The name of the file.
	 *
	 * Returns:
	 *     This image to aid method chaining.
	 */
	public auto setFile(this T)(string file)
	{
		this._tk.eval("%s configure -file {%s}", this.id, file);

		return cast(T) this;
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
		return this._tk.getResult!(string);
	}

	/**
	 * Set the image gamma.
	 *
	 * Params:
	 *     gamma = The destination gamma.
	 *
	 * Returns:
	 *     This image to aid method chaining.
	 */
	public auto setGamma(this T)(double gamma)
	{
		if (gamma < 0)
		{
			gamma = 1;
		}

		this._tk.eval("%s configure -gamma %s", this.id, gamma);

		return cast(T) this;
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
		return this._tk.getResult!(string);
	}

	/**
	 * Set the image height.
	 *
	 * Params:
	 *     height = The height to crop the image to.
	 *
	 * Returns:
	 *     This image to aid method chaining.
	 */
	public auto setHeight(this T)(int height)
	{
		this._tk.eval("%s configure -height %s", this.id, height);

		return cast(T) this;
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
		return this._tk.getResult!(string);
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
	 *
	 * Returns:
	 *     This image to aid method chaining.
	 */
	public auto setPalette(this T)(string palette)
	{
		this._tk.eval("%s configure -palette {%s}", this.id, palette);

		return cast(T) this;
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
		return this._tk.getResult!(string);
	}

	/**
	 * Set the image width.
	 *
	 * Params:
	 *     width = The width to crop the image to.
	 *
	 * Returns:
	 *     This image to aid method chaining.
	 */
	public auto setWidth(this T)(int width)
	{
		this._tk.eval("%s configure -width %s", this.id, width);

		return cast(T) this;
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
		return this._tk.getResult!(string);
	}

	/**
	 * Destroy this image.
	 *
	 * Caveats:
	 *     Once an image is destroyed it can no longer be referenced in your 
	 *     code or a segmentation fault will occur and potentially crash your 
	 *     program.
	 */
	public void destroy()
	{
		this._tk.eval("image delete %s", this.id);
		super.destroy();
	}
}

/**
 * Template to base64 encode files at compile time.
 *
 * Params:
 *     file = The file name to encode and embed.
 */
private template base64Encode(string file)
{
	import std.base64;

	private string getData()
	{
		return Base64.encode(cast(ubyte[])import(file));
	}

	enum base64Encode = getData();
}
