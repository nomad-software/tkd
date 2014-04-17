/**
 * Widget module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.keyboardfocus;

/**
 * Keyboard values values of widgets.
 */
enum KeyboardFocus : string
{
	normal  = "ttk::takefocus", /// Default focus setting.
	enable  = "1",              /// Enable widget focus.
	disable = "0",              /// Disable widget focus.
}
