/**
 * Dialog module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.dialog.messagedialogbutton;

/**
 * Symbolic names for message dialog buttons.
 *
 * See_Also:
 *     $(LINK2 ./messagedialog.html, tkd.dialog.messagedialog) $(BR)
 */
enum MessageDialogButton : string
{
	abort  = "abort",  /// The 'abort' button.
	cancel = "cancel", /// The 'cancel' button.
	ignore = "ignore", /// The 'ignore' button.
	no     = "no",     /// The 'no' button.
	ok     = "ok",     /// The 'ok' button.
	retry  = "retry",  /// The 'retry' button.
	yes    = "yes",    /// The 'yes' button.
}
