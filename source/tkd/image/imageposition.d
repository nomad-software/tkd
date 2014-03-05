/**
 * Image module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.image.imageposition;

/**
 * Position of image relative to the text.
 */
enum ImagePosition : string
{
	text   = "text",   /// Only show text.
	image  = "image",  /// Only show image.
	center = "center", /// Center the text on the image.
	top    = "top",    /// Position the image above the text.
	bottom = "bottom", /// Position the image below the text.
	left   = "left",   /// Position the image to the left of the text.
	right  = "right",  /// Position the image to the right of the text.
	none   = "none",   /// Default image position.
}
