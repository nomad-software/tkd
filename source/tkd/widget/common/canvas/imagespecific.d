/**
 * Image specific module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.common.canvas.imagespecific;

/**
 * These are common commands that apply to all widgets that have them injected.
 */
mixin template ImageSpecific()
{
	/**
	 * The image.
	 */
	private Image _image;

	/**
	 * The active image.
	 */
	private Image _activeImage;

	/**
	 * The disabled image.
	 */
	private Image _disabledImage;

	/**
	 * Get the image.
	 *
	 * Returns:
	 *     The image;
	 */
	public Image getImage()
	{
		return this._image;
	}

	/**
	 * Set the image.
	 *
	 * Params:
	 *    image = The image.
	 *
	 * Returns:
	 *     This item to aid method chaining.
	 *
	 * See_Also:
	 *     $(LINK2 ../../../image/gif.html, tkd.image.gif) $(BR)
	 *     $(LINK2 ../../../image/image.html, tkd.image.image) $(BR)
	 *     $(LINK2 ../../../image/png.html, tkd.image.png) $(BR)
	 */
	public auto setImage(this T)(Image image)
	{
		this._image = image;

		if (this._parent && this._image)
		{
			this._tk.eval("%s itemconfigure %s -image %s", this._parent.id, this.id, this._image.id);
		}

		return cast(T) this;
	}

	/**
	 * Get the active image.
	 *
	 * Returns:
	 *     The active image;
	 */
	public Image getActiveImage()
	{
		return this._activeImage;
	}

	/**
	 * Set the active image.
	 *
	 * Params:
	 *    image = The active image.
	 *
	 * Returns:
	 *     This item to aid method chaining.
	 *
	 * See_Also:
	 *     $(LINK2 ../../../image/gif.html, tkd.image.gif) $(BR)
	 *     $(LINK2 ../../../image/image.html, tkd.image.image) $(BR)
	 *     $(LINK2 ../../../image/png.html, tkd.image.png) $(BR)
	 */
	public auto setActiveImage(this T)(Image image)
	{
		this._activeImage = image;

		if (this._parent && this._activeImage)
		{
			this._tk.eval("%s itemconfigure %s -activeimage %s", this._parent.id, this.id, this._activeImage.id);
		}

		return cast(T) this;
	}

	/**
	 * Get the disabled image.
	 *
	 * Returns:
	 *     The disabled image;
	 */
	public Image getDisabledImage()
	{
		return this._disabledImage;
	}

	/**
	 * Set the disabled image.
	 *
	 * Params:
	 *    image = The disabled image.
	 *
	 * Returns:
	 *     This item to aid method chaining.
	 *
	 * See_Also:
	 *     $(LINK2 ../../../image/gif.html, tkd.image.gif) $(BR)
	 *     $(LINK2 ../../../image/image.html, tkd.image.image) $(BR)
	 *     $(LINK2 ../../../image/png.html, tkd.image.png) $(BR)
	 */
	public auto setDisabledImage(this T)(Image image)
	{
		this._disabledImage = image;

		if (this._parent && this._disabledImage)
		{
			this._tk.eval("%s itemconfigure %s -disabledimage %s", this._parent.id, this.id, this._disabledImage.id);
		}

		return cast(T) this;
	}
}
