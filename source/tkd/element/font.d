/**
* Element module.
*
* License:
*     MIT. See LICENSE for full details.
*/
module tkd.element.font;

/**
* Standard supported fonts.
*/
enum Font : string {
	default_ = "",
	arial = "Arial",
	courier = "Courier",
	gothic = "Gothic",
	helvetica = "Helvetica",
	symbol = "Symbol",	
	times = "Times",
	timesNewRoman = "Times New Roman",             
}

/**
* Windows only fonts.
*/
version (Windows)
{
	enum WindowsFont : string
	{
		comicSans = "Comic Sans MS",
	}
}

/**
* Font weight options.
*/
enum FontWeight : string {
	default_ = "",
	normal = "",
	bold = "bold",
}

/**
* Font style options.
*/
enum FontStyle : string {
	default_ = "",
	italic = "italic",
	underline = "underline",
	overstrike = "overstrike",
}

/**
* Font slant options.
*/
enum FontSlant : string {
	default_ = "",
	normal = "",
	roman = "",
	italic = "italic",
}

/**
* Font underline options.
*/
enum FontUnderline : string {
	default_ = "",
	False = "",
	True = "underline",             
	no = "",
	yes = "underline",
	normal = "",
	underline = "underline",
	off = "",
	on = "underline",
}

/**
* Font overstrike options.
*/
enum FontOverstrike : string {
	default_ = "",
	False = "",
	True = "overstrike",
	no = "",
	yes = "overstrike",
	normal = "",
	overstrike = "overstrike",
	off = "",
	on = "overstrike",
}

/**
* Font size default.
*/
enum FontSize : int {
	default_ = 0,
}
