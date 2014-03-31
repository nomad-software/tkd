/**
 * Widget module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.menubuttondirection;

/**
 * Placement of a menu relative to a menu button.
 */
enum MenuButtonDirection : string
{
	above = "above", /// Above the menu button.
	below = "below", /// Below the menu button.
	flush = "flush", /// Directly over the menu button.
	left  = "left",  /// Left of the menu button.
	right = "right", /// Right of the menu button.
}
