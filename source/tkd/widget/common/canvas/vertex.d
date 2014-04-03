/**
 * Vertex module.
 *
 * License:
 *     MIT. See LICENSE for full details.
 */
module tkd.widget.common.canvas.vertex;

/**
 * These are common commands that apply to all widgets that have them injected.
 */
mixin template Vertex()
{
	/**
	 * The style of the joins.
	 */
	private string _joinStyle;

	/**
	 * The smoothing method used for the line.
	 */
	private string _smoothMethod;

	/**
	 * Defines how many splines to use for smoothing.
	 */
	private int _splineSteps;

	/**
	 * Get the join style.
	 *
	 * Returns:
	 *     The join style.
	 */
	public string getJoinStyle()
	{
		return this._joinStyle;
	}

	/**
	 * Specifies the ways in which joints are to be drawn at the vertices of 
	 * the line. If this option is not specified then it defaults to round. If 
	 * the line only contains two points then this option is irrelevant.
	 *
	 * Params:
	 *    joinStyle = The join style.
	 *
	 * Returns:
	 *     This item to aid method chaining.
	 *
	 * See_Also:
	 *     $(LINK2 ../../canvas.html#CanvasLineJoinStyle, tkd.widget.canvas.CanvasLineJoinStyle)
	 */
	public auto setJoinStyle(this T)(string joinStyle)
	{
		this._joinStyle = joinStyle;

		if (this._parent && this._joinStyle.length)
		{
			this._tk.eval("%s itemconfigure %s -joinstyle {%s}", this._parent.id, this.id, this._joinStyle);
		}

		return cast(T) this;
	}

	/**
	 * Get the smooth method.
	 *
	 * Returns:
	 *     The smooth method.
	 */
	public string getSmoothMethod()
	{
		return this._smoothMethod;
	}

	/**
	 * If the smoothing method is bezier, this indicates that the line should 
	 * be drawn as a curve, rendered as a set of quadratic splines: one spline 
	 * is drawn for the first and second line segments, one for the second and 
	 * third, and so on. Straight-line segments can be generated within a curve 
	 * by duplicating the end-points of the desired line segment. If the 
	 * smoothing method is raw, this indicates that the line should also be 
	 * drawn as a curve but where the list of coordinates is such that the 
	 * first coordinate pair (and every third coordinate pair thereafter) is a 
	 * knot point on a cubic bezier curve, and the other coordinates are 
	 * control points on the cubic bezier curve. Straight line segments can be 
	 * generated within a curve by making control points equal to their 
	 * neighbouring knot points. If the last point is a control point and not a 
	 * knot point, the point is repeated (one or two times) so that it also 
	 * becomes a knot point.
	 *
	 * Params:
	 *    smoothMethod = The smooth method.
	 *
	 * Returns:
	 *     This item to aid method chaining.
	 *
	 * See_Also:
	 *     $(LINK2 ../../canvas.html#CanvasLineSmoothMethod, tkd.widget.canvas.CanvasLineSmoothMethod)
	 */
	public auto setSmoothMethod(this T)(string smoothMethod)
	{
		this._smoothMethod = smoothMethod;

		if (this._parent && this._smoothMethod.length)
		{
			this._tk.eval("%s itemconfigure %s -smooth {%s}", this._parent.id, this.id, this._smoothMethod);
		}

		return cast(T) this;
	}

	/**
	 * Get smooth method spline steps.
	 *
	 * Returns:
	 *     The smooth method spline steps.
	 */
	public int getSmoothSplineSteps()
	{
		return this._splineSteps;
	}

	/**
	 * Specifies the degree of smoothness desired for curves: each spline will 
	 * be approximated with number line segments.
	 *
	 * Params:
	 *    splineSteps = The smooth method spline steps.
	 *
	 * Returns:
	 *     This item to aid method chaining.
	 */
	public auto setSmoothSplineSteps(this T)(int splineSteps)
	{
		this._splineSteps = splineSteps;

		if (this._parent && this._splineSteps > 0)
		{
			this._tk.eval("%s itemconfigure %s -splinesteps %s", this._parent.id, this.id, this._splineSteps);
		}

		return cast(T) this;
	}
}
