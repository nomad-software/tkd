/**
 * Bounding Box module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.common.boundingbox;

/**
 * These are common commands that apply to all widgets that have them injected.
 */
mixin template BoundingBox()
{
	import std.algorithm;
	import std.array;
	import std.conv;

	/**
	 * Get the bounding box of a character in the text.
	 *
	 * Params:
	 *     charIndex = The index of the character to get the bounding box of.
	 *
	 * Returns:
	 *     An int array representing the bounding box in pixels.
	 */
	public int[] getCharBoundingBox(int charIndex)
	{
		this._tk.eval("%s bbox %s", this.id, charIndex);
		return this._tk.getResult!(string).split().map!(to!(int)).array;
	}
}
