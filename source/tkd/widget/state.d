/**
 * Widget module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.state;

/**
 * State values of widgets.
 */
enum State : string
{
	normal     = "normal",     /// Normal state.
	active     = "active",     /// Active state.
	disabled   = "disabled",   /// Disabled state.
	focus      = "focus",      /// Focused state.
	pressed    = "pressed",    /// Pressed state.
	selected   = "selected",   /// Selected state.
	background = "background", /// Background state.
	readonly   = "readonly",   /// Readonly state.
	alternate  = "alternate",  /// Alternate state.
	invalid    = "invalid",    /// Invalid state.
	hover      = "hover",      /// Hover state.
}
