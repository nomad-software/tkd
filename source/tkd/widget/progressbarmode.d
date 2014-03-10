/**
 * Widget module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.progressbarmode;

/**
 * The mode of a progress bar.
 */
enum ProgressBarMode : string
{
	determinate = "determinate",     /// Shows the amount completed relative to the total amount of work to be done.
	indeterminate = "indeterminate", /// Provides an animated display to let the user know that something is happening.
}
