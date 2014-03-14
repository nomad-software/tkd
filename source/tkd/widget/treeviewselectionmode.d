/**
 * Widget module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.treeviewselectionmode;

/**
 * Tree view selection modes.
 */
enum TreeViewSelectionMode : string
{
	browse   = "browse",   /// The default mode, allows one selection only.
	extended = "extended", /// Allows multiple selections to be made.
	none     = "none",     /// Disabled all selection.
}
