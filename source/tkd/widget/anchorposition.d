/**
 * Widget module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.anchorposition;

/**
 * Anchor positions of widgets.
 */
enum AnchorPosition : string
{
	north     = "n",      /// Anchor to the North.
	northEast = "ne",     /// Anchor to the North East.
	east      = "e",      /// Anchor to the East.
	southEast = "se",     /// Anchor to the South East.
	south     = "s",      /// Anchor to the South.
	southWest = "sw",     /// Anchor to the South West.
	west      = "w",      /// Anchor to the West.
	northWest = "nw",     /// Anchor to the North West.
	center    = "center", /// Anchor centered.
}
