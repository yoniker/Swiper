import 'package:flutter/widgets.dart';

/// Displays an overlay Widget anchored directly above the center of this
/// [AnchoredOverlay].
///
/// The overlay Widget is created by invoking the provided [overlayBuilder].
///
/// The [anchor] position is provided to the [overlayBuilder], but the builder
/// does not have to respect it. In other words, the [overlayBuilder] can
/// interpret the meaning of "anchor" however it wants - the overlay will not
/// be forced to be centered about the [anchor].
///
/// The overlay built by this [AnchoredOverlay] can be conditionally shown
/// and hidden by settings the [showOverlay] property to true or false.
///
/// The [overlayBuilder] is invoked every time this Widget is rebuilt.

// In essence what this mean is that, the [AnchoredOverlay] is a widget that shows or display
// an overlay Widget which is centered above whatever child argument is passed to it.
// This is no different than stacking a Centered Widget above the `child` except it is
// an overlay rather than a stack.

// Why we need this; this gives us the oppotunity to have our MatchCard right above all the
// built-in Widget stack of our scaffold. Thus, when we try to drag a card over the bottom Navigation bar
// the card goes over appearing as if we are dragging them out of the screen.
class AnchoredOverlay extends StatelessWidget {
  final bool showOverlay;
  final Widget Function(BuildContext, Rect anchorBounds, Offset anchor)
      overlayBuilder;
  final Widget child;

  AnchoredOverlay({
    key,
    this.showOverlay = false,
    this.overlayBuilder,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
      // This LayoutBuilder gives us the opportunity to measure the above
      // Container to calculate the "anchor" point at its center.
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          // The OverlayBuilder allows us to
          return OverlayBuilder(
            showOverlay: showOverlay,
            overlayBuilder: (BuildContext overlayContext) {
              // To calculate the "anchor" point we grab the render box of
              // our parent Container and then we find the center of that box.
              RenderBox box = context.findRenderObject() as RenderBox;
              final topLeft =
                  box.size.topLeft(box.localToGlobal(const Offset(0.0, 0.0)));
              final bottomRight = box.size
                  .bottomRight(box.localToGlobal(const Offset(0.0, 0.0)));
              final Rect anchorBounds = new Rect.fromLTRB(
                topLeft.dx,
                topLeft.dy,
                bottomRight.dx,
                bottomRight.dy,
              );
              final anchorCenter = box.size.center(topLeft);

              return overlayBuilder(overlayContext, anchorBounds, anchorCenter);
            },
            child: child,
          );
        },
      ),
    );
  }
}

class OverlayBuilder2 extends StatelessWidget {
  const OverlayBuilder2({Key key, @required this.builder}) : super(key: key);

  final Widget Function(BuildContext) builder;

  @override
  Widget build(BuildContext context) {
    return builder(context);
  }
}

/// Displays an overlay Widget as constructed by the given [overlayBuilder].
///
/// The overlay built by the [overlayBuilder] can be conditionally shown
/// and hidden by settings the [showOverlay] property to true or false.
///
/// The [overlayBuilder] is invoked every time this Widget is rebuilt.
///
/// Implementation note: the reason we rebuild the overlay every time our
/// state changes is because there doesn't seem to be any better way to
/// invalidate the overlay itself than to invalidate this Widget. Remember,
/// overlay Widgets exist in [OverlayEntry]s which are inaccessible to
/// outside Widgets. But if a better approach is found then feel free to use it.
class OverlayBuilder extends StatefulWidget {
  final bool showOverlay;
  final Widget Function(BuildContext) overlayBuilder;
  final Widget child;

  OverlayBuilder({
    key,
    this.showOverlay = false,
    this.overlayBuilder,
    this.child,
  }) : super(key: key);

  @override
  _OverlayBuilderState createState() => new _OverlayBuilderState();
}

class _OverlayBuilderState extends State<OverlayBuilder> {
  OverlayEntry overlayEntry;

  @override
  void initState() {
    super.initState();

    if (widget.showOverlay) {
      WidgetsBinding.instance.addPostFrameCallback((_) => showOverlay());
    }
  }

  @override
  void didUpdateWidget(OverlayBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) => syncWidgetAndOverlay());
  }

  @override
  void reassemble() {
    super.reassemble();
    WidgetsBinding.instance.addPostFrameCallback((_) => syncWidgetAndOverlay());
  }

  @override
  void dispose() {
    if (isShowingOverlay()) {
      hideOverlay();
    }

    super.dispose();
  }

  bool isShowingOverlay() => overlayEntry != null;

  void showOverlay() {
    if (overlayEntry == null) {
      // Create the overlay.
      overlayEntry = new OverlayEntry(
        builder: widget.overlayBuilder,
      );
      addToOverlay(overlayEntry);
    } else {
      // Rebuild overlay.
      buildOverlay();
    }
  }

  /// This method adds the given `entry` parameter to the Existing Overlay context.
  void addToOverlay(OverlayEntry entry) {
    Overlay.of(context).insert(entry);
  }

  /// Hiding the overlay removes the overlayEntry constructed from the existing
  /// Overlay context.
  ///
  /// Called whenever the `showOverlay` Constructor parameter of this [OverlayBuilder] class
  /// is set to false.
  void hideOverlay() {
    if (overlayEntry != null) {
      if (overlayEntry?.mounted == true) overlayEntry?.remove();
      overlayEntry = null;
    }
  }

  /// A method that is called when this Widget need to be rebuild.
  /// Called at every re-build of this Widget.
  ///
  /// It checks to see if the `showOverlay` parameter has been set to null or not.
  /// It then rebuilds the overlay or hide it depending on what the above condition yields.
  void syncWidgetAndOverlay() {
    if (isShowingOverlay() && !widget.showOverlay) {
      hideOverlay();
    } else if (!isShowingOverlay() && widget.showOverlay) {
      showOverlay();
    }
  }

  /// Called at the First Initialization of this Widget.
  ///
  /// This essentially rebuilds the Widget by calling unto the build method
  /// of this Stateful Widget.
  void buildOverlay() {
    overlayEntry?.markNeedsBuild();
  }

  @override
  Widget build(BuildContext context) {
    // This essentially tells the FrameWork to call the "buildOverlay" function
    // after the drawing of this Frame has ended.
    // This allows us to skip/escape any runtime errors that may occur when "setState()"
    // or "markNeedsBuild()" is called during  the drawing of this Frame.
    WidgetsBinding.instance.addPostFrameCallback((_) => buildOverlay());

    // Note: the child being return here is just a placeholder upon which
    // the actual overlay is being built.
    return widget.child;
  }
}

/// This is a Widget that positions its child at the center of its parent [Widget]
/// based on the Offset of its parent.
///
/// Note; this can also be achieved by using a Center [Widget].
/// 
/// * Check out Center.
class CenterAbout extends StatelessWidget {
  final Offset position;
  final Widget child;

  CenterAbout({
    key,
    this.position,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Positioned(
      left: position.dx,
      top: position.dy,
      child: FractionalTranslation(
        translation: const Offset(-0.5, -0.5),
        child: child,
      ),
    );
  }
}
