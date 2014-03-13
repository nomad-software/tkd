/**
 * TkdApplication module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.theme;

/**
 * Imports.
 */
import std.system;

/**
 * Standard themes.
 */
enum Theme : string
{
	alt       = "alt",     /// The alternate theme.
	classic   = "classic", /// The classic theme.
	default_  = "default", /// The default theme.
	clam      = "clam",    /// The Clam theme.
}

/**
 * Mac OSX only themes.
 */
version (OSX)
{
	enum MacOSXTheme : string
	{
		aqua = "aqua", /// Native theme of Mac OSX.
	}
}

/**
 * Windows only themes.
 */
version (Windows)
{
	enum WindowsTheme : string
	{
		winnative = "winnative", /// The native theme of Windows.
		xpnative  = "xpnative",  /// The native theme of Window XP.
	}
}
