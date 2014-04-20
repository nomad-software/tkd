/**
 * Dialog module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.dialog.messagedialogtype;

/**
 * Arranges for a predefined set of buttons to be displayed. The following values are possible for predefinedType:
 *
 * See_Also:
 *     $(LINK2 ./messagedialog.html, tkd.dialog.messagedialog) $(BR)
 */
enum MessageDialogType : string
{
	abortretryignore = "abortretryignore", /// Displays three buttons whose symbolic names are abort, retry and ignore.
	ok               = "ok",               /// Displays one button whose symbolic name is ok.
	okcancel         = "okcancel",         /// Displays two buttons whose symbolic names are ok and cancel.
	retrycancel      = "retrycancel",      /// Displays two buttons whose symbolic names are retry and cancel.
	yesno            = "yesno",            /// Displays two buttons whose symbolic names are yes and no.
	yesnocancel      = "yesnocancel",      /// Displays three buttons whose symbolic names are yes, no and cancel.
}
