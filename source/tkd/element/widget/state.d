/**
 * State enum module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.element.widget.state;

/**
 * State values of widgets.
 */
enum State : string
{
	/**
	 * The default state.
	 */
	normal = "normal",

	/*
	 * The mouse cursor is over the widget and pressing a mouse button will 
	 * cause some action to occur. (aka “prelight” (Gnome), “hot” (Windows), 
	 * “hover”).
	 */
	active = "active",

	/*
	 * Widget is disabled under program control (aka “unavailable”, “inactive”)
	 */
	disabled = "disabled",

	/*
	 * Widget has keyboard focus
	 */
	focus = "focus",

	/*
	 * Widget is being pressed (aka “armed” in Motif).
	 */
	pressed = "pressed",

	/*
	 * “On”, “true”, or “current” for things like checkbuttons and radiobuttons.
	 */
	selected = "selected",

	/*
	 * Windows and the Mac have a notion of an “active” or foreground window. 
	 * The background state is set for widgets in a background window, and 
	 * cleared for those in the foreground window.
	 */
	background = "background",

	/*
	 * Widget should not allow user modification.
	 */
	readonly = "readonly",

	/*
	 * A widget-specific alternate display format. For example, used for 
	 * checkbuttons and radiobuttons in the “tristate” or “mixed” state, and 
	 * for buttons with -default active.
	 */
	alternate = "alternate",

	/*
	 * The widget's value is invalid. (Potential uses: scale widget value out of bounds, entry widget value failed validation.)
	 */
	invalid = "invalid",

	/*
	 * The mouse cursor is within the widget. This is similar to the active 
	 * state; it is used in some themes for widgets that provide distinct 
	 * visual feedback for the active widget in addition to the active element 
	 * within the widget.
	 */
	hover = "hover",
}
