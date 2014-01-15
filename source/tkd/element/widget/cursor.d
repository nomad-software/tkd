/**
 * Cursor enum module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.element.widget.cursor;

/**
 * Cross-platform cursor values.
 */
enum Cursor : string
{
	xCursor                 = "X_cursor",
	arrow                   = "arrow",
	basedArrowDown          = "based_arrow_down",
	basedArrowUp            = "based_arrow_up",
	boat                    = "boat",
	bogosity                = "bogosity",
	bottomLeftCorner        = "bottom_left_corner",
	bottomRightCorner       = "bottom_right_corner",
	bottomSide              = "bottom_side",
	bottomTee               = "bottom_tee",
	boxSpiral               = "box_spiral",
	centerPtr               = "center_ptr",
	circle                  = "circle",
	clock                   = "clock",
	coffeeMug               = "coffee_mug",
	cross                   = "cross",
	crossReverse            = "cross_reverse",
	crosshair               = "crosshair",
	diamondCross            = "diamond_cross",
	dot                     = "dot",
	dotbox                  = "dotbox",
	doubleArrow             = "double_arrow",
	draftLarge              = "draft_large",
	draftSmall              = "draft_small",
	drapedBox               = "draped_box",
	exchange                = "exchange",
	fleur                   = "fleur",
	gobbler                 = "gobbler",
	gumby                   = "gumby",
	hand1                   = "hand1",
	hand2                   = "hand2",
	heart                   = "heart",
	icon                    = "icon",
	ironCross               = "iron_cross",
	leftPtr                 = "left_ptr",
	leftSide                = "left_side",
	leftTee                 = "left_tee",
	leftbutton              = "leftbutton",
	llAngle                 = "ll_angle",
	lrAngle                 = "lr_angle",
	man                     = "man",
	middlebutton            = "middlebutton",
	mouse                   = "mouse",
	pencil                  = "pencil",
	pirate                  = "pirate",
	plus                    = "plus",
	questionArrow           = "question_arrow",
	rightPtr                = "right_ptr",
	rightSide               = "right_side",
	rightTee                = "right_tee",
	rightbutton             = "rightbutton",
	rtlLogo                 = "rtl_logo",
	sailboat                = "sailboat",
	sbDownArrow             = "sb_down_arrow",
	sbHorizontalDoubleArrow = "sb_h_double_arrow",
	sbLeftArrow             = "sb_left_arrow",
	sbRightArrow            = "sb_right_arrow",
	sbUpArrow               = "sb_up_arrow",
	sbVerticalDoubleArrow   = "sb_v_double_arrow",
	shuttle                 = "shuttle",
	sizing                  = "sizing",
	spider                  = "spider",
	spraycan                = "spraycan",
	star                    = "star",
	target                  = "target",
	tcross                  = "tcross",
	topLeftArrow            = "top_left_arrow",
	topLeftCorner           = "top_left_corner",
	topRightCorner          = "top_right_corner",
	topSide                 = "top_side",
	topTee                  = "top_tee",
	trek                    = "trek",
	ulAngle                 = "ul_angle",
	umbrella                = "umbrella",
	urAngle                 = "ur_angle",
	watch                   = "watch",
	xterm                   = "xterm",

}

/**
 * Windows only cursor values.
 */
version(Windows)
{
	enum WindowsCursor : string
	{
		no       = "no",
		starting = "starting",
		size     = "size",
		sizeNeSw = "size_ne_sw",
		sizeNs   = "size_ns",
		sizeNwSe = "size_nw_se",
		sizeWe   = "size_we",
		upArrow  = "uparrow",
		wait     = "wait",
	}
}

/**
 * MacOSX only cursor values.
 */
version(OSX)
{
	enum MacOSXCursor : string
	{
		copyArrow             = "copyarrow",
		aliasArrow            = "aliasarrow",
		contextualMenuArrow   = "contextualmenuarrow",
		text                  = "text",
		crosshair             = "cross",
		closedHand            = "closedhand",
		openHand              = "openhand",
		pointingHand          = "pointinghand",
		resizeLeft            = "resizeleft",
		resizeRight           = "resizeright",
		resizeLeftRight       = "resizeleftright",
		resizeUp              = "resizeup",
		resizeDown            = "resizedown",
		resizeUpDown          = "resizeupdown",
		none                  = "none",
		notAllowed            = "notallowed",
		poof                  = "poof",
		countingUpHand        = "countinguphand",
		countingDownHand      = "countingdownhand",
		countingUpAndDownHand = "countingupanddownhand",
		spinning              = "spinning",
	}
}
