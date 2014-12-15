part of pixies.engine;

class GLEngine extends Controller {
  
  /*
   * Tips:
   * 
   * Avoid extraneous glBindFramebuffer calls. Use multiple attachments to a
   * FBO rather than managing multiple FBOs.
   * 
   * For occlusion queries, using GL_ANY_SAMPLES_PASSED may be more effective
   * than GL_SAMPLES_PASSED, as a rendering doesn't have to continue as soon as
   * one fragment passed.
   * 
   * To accurately compute the length of a gradient, avoid fwidth(v); instead
   * use sqrt(dFdx(v) * dFdx(v) + dFdy(v) * dFdy(v)).
   * 
   * The maximum size of a 2D texture is given by
   * webgl.getParameter(webgl.MAX_TEXTURE_SIZE).
   * 
   * Rendering to a floating-point texture may not be supported, even if the
   * OES_texture_float extension is supported. Typically, this fails on current
   * mobile hardware. To check if this is supported, you have to call the WebGL
   * checkFramebufferStatus() function.
   */
  
  /////////////////////////////////////////////////////////////////////////////
  ////  Event Types  //////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  
  static const CHANNEL_CONTEXT_LOST = 'contextLost';
  static const CHANNEL_CONTEXT_RESTORED = 'contextRestored';
  static const CHANNEL_RESIZE = 'resize';
  static const CHANNEL_RENDER = 'render';
  
  /////////////////////////////////////////////////////////////////////////////
  ////  Constructor  //////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  
  /// Constructor.
  GLEngine({
    html.CanvasElement canvas,
    html.DivElement statsElement,
    int backgroundColor: 0xFFFFFF,
    bool playing: true,
    bool alpha: false,
    bool antialias: false
  }) : this.canvas = canvas == null ? new html.CanvasElement() : canvas {
    _backgroundColor = backgroundColor;
    _alpha = alpha;
    _antialias = _antialias;
    
    _objectsCollection = new ListCollection(source: _objects, onAdded: _onObjectAdded, onRemoved: _onObjectRemoved);
    this.statsElement = statsElement;
    
    canvas.onKeyDown.listen(_onKeyEvent);
    canvas.onKeyUp.listen(_onKeyEvent);
    canvas.onKeyPress.listen(_onKeyEvent);
    canvas.onMouseDown.listen(_onMouseEvent);
    canvas.onMouseUp.listen(_onMouseEvent);
    canvas.onMouseMove.listen(_onMouseEvent);
    canvas.onMouseOut.listen(_onMouseEvent);
    canvas.onContextMenu.listen(_onMouseEvent);
    canvas.onMouseWheel.listen(_onMouseWheelEvent);
    
    canvas.onWebGlContextLost.listen(_onWebGLContextLost);
    canvas.onWebGlContextRestored.listen(_onWebGLContextRestored);
    
    canvas.onResize.listen(_onResize);
    
    _initializeContext();
    
    this.playing = playing;
  }
  
  /////////////////////////////////////////////////////////////////////////////
  //// Misc Properties  ///////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  bool _alpha;
  bool _antialias;
  
  /// The [html.CanvasElement] in use.
  final html.CanvasElement canvas;
  
  gl.RenderingContext _rawContext;
  /// The raw [gl.RenderingContext] context.
  gl.RenderingContext get rawContext => _rawContext;
  
  /// Indicates if the WebGL context is lost.
  bool get isContextLost => _rawContext == null;
  
  _GLStats _stats;
  Stopwatch _statsWatch;
  
  html.DivElement get statsElement => _stats != null ? _stats.element : null;
  void set statsElement(html.DivElement value) {
    if (value == null) {
      _stats = null;
      _statsWatch = null;
    } else {
      _stats = new _GLStats(value);
      _statsWatch = new Stopwatch();
    }
  }
  
  /////////////////////////////////////////////////////////////////////////////
  ////  Events Channels  //////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  
  /// Add a listener to the [CHANNEL_CONTEXT_LOST] channel.
  void onContextLost(EventListener listener) {
    addEventListener(CHANNEL_CONTEXT_LOST, listener);
  }
  
  /// Add a listener to the [CHANNEL_CONTEXT_RESTORED] channel.
  void onContextRestored(EventListener listener) {
    addEventListener(CHANNEL_CONTEXT_RESTORED, listener);
  }
  
  /// Add a listener to the [CHANNEL_RESIZE] channel.
  void onResize(EventListener listener) {
    addEventListener(CHANNEL_RESIZE, listener);
  }
  
  /// Add a listener to the [CHANNEL_RENDER] channel.
  void onRender(EventListener listener) {
    addEventListener(CHANNEL_RENDER, listener);
  }
  
  /////////////////////////////////////////////////////////////////////////////
  ////  GLObjects Handling  ///////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  final List<GLObject> _objects = <GLObject>[];
  ListCollection<GLObject> _objectsCollection;
  ListCollection<GLObject> get objects => _objectsCollection;
  
  void _onObjectAdded(GLObject object) {
    object.engine = this;
  }
  
  void _onObjectRemoved(GLObject object) {
    object.engine = null;
  }
  
  /////////////////////////////////////////////////////////////////////////////
  ////  Lifecycle Handling  ///////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  
  /// Initialize the WebGL context.
  void _initializeContext() {
    try {
      if (! gl.RenderingContext.supported)
        throw 'WebGL is not supported!';
      
      final context = _rawContext = canvas.getContext3d(
          alpha: _alpha,
          antialias: _antialias,
          depth: false,
          stencil: true,
          premultipliedAlpha: false,
          preserveDrawingBuffer: false
        );
      
      if (context is! gl.RenderingContext) {
        _destroyContext();
        throw 'Unable to initialize WebGL!';
      }
      
      context.enable(gl.BLEND);
      context.disable(gl.STENCIL_TEST);
      context.disable(gl.DEPTH_TEST);
      context.disable(gl.CULL_FACE);
      context.pixelStorei(gl.UNPACK_PREMULTIPLY_ALPHA_WEBGL, 1);
      
      blendMode = BlendMode.NORMAL;
  
      context.colorMask(true, true, true, true);
      _uploadBackgroundColor();
      _updateSize();
      
      final length = _objects.length;
      for (int index = 0; index < _objects.length; index++)
        _objects[index].createGraphics();
      
    } catch (error) {
      final container = canvas.parentNode;
      if (container != null) {
        final message = gl.RenderingContext.supported
            ? '''
This page requires a browser that supports WebGL.<br/>
<a href="http://get.webgl.org">Click here to upgrade your browser.</a>
'''
            : '''
It doesn't appear your computer can support WebGL.<br/>
<a href="http://get.webgl.org/troubleshooting/">Click here for more information.</a>
''';
        
        final div = new html.DivElement()
            ..innerHtml = '''
<table style="background-color: #8CE; width: 100%; height: 100%;"><tr>
  <td align="center">
    <div style="display: table-cell; vertical-align: middle;">
      <div style="">$message</div>
    </div>
  </td>
</tr></table>
<br/><br/>Status: ${error}
''';
        canvas.replaceWith(div);
      }
    }
  }
  
  void _destroyContext() {
    final length = _objects.length;
    for (int index = 0; index < _objects.length; index++)
      _objects[index].destroyGraphics();
    
    _rawContext = null;
    _blendMode = null;
    
    _activeProgram = null;
    _activeTexture = null;
  }
  
  /////////////////////////////////////////////////////////////////////////////
  ////  Context Lost/Restored Handling  ///////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  
  void _onWebGLContextLost(gl.ContextEvent event) {
    print('_onWebGLContextLost:    $event');
    event.preventDefault();
    _destroyContext();
    dispatchEventWith(CHANNEL_CONTEXT_LOST, this);
  }
  
  void _onWebGLContextRestored(gl.ContextEvent event) {
    print('_onWebGLContextRestored:    $event');
    _initializeContext();
    _requestAnimationFrame();
    dispatchEventWith(CHANNEL_CONTEXT_RESTORED, this);
  }
  
  /////////////////////////////////////////////////////////////////////////////
  ////  Animation Frame Handling  /////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  int _animationFrameCallbackId = -1;
  num _lastTotalTime = 0;
  
  void _requestAnimationFrame() {
    if (_playing && _rawContext != null) {
      _animationFrameCallbackId = html.window.requestAnimationFrame(_onAnimationFrame);
    }
  }
  
  void _onAnimationFrame(num totalTime) {
    final timePassed = totalTime - _lastTotalTime;
    _lastTotalTime = totalTime;
    _animationFrameCallbackId = -1;
    
    if (_stats == null) {
      advanceTime(timePassed);
      
    } else {
      _statsWatch..reset()..start();
      advanceTime(timePassed);
      _statsWatch.stop();
      _stats.addTimes(timePassed, _statsWatch.elapsedMilliseconds);
    }
    
    _requestAnimationFrame();
  }
  
  bool _playing;
  /// Indicate if the stage is currently playing and rendering.
  bool get playing => _playing;
  void set playing(bool value) {
    _playing = value;
    if (! value) {
      if (_animationFrameCallbackId > 0) {
        html.window.cancelAnimationFrame(_animationFrameCallbackId);
        _animationFrameCallbackId = -1;
      }
    } else if (_animationFrameCallbackId < 0) {
      _requestAnimationFrame();
    }
  }
  
  void advanceTime(num passedMilliseconds) {
    if (_rawContext == null) return;
    dispatchEventWith(CHANNEL_RENDER, this);
    
    if (_sizeIsDirty) _updateSize();
    
    _rawContext.clear(gl.COLOR_BUFFER_BIT | gl.STENCIL_BUFFER_BIT);
    
    final length = _objects.length;
    for (int index = 0; index < length; index++) {
      _objects[index].advanceTime(passedMilliseconds);
    }
    
    flush();
  }
  
  /////////////////////////////////////////////////////////////////////////////
  ////  Key Events Handling  //////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  
  void _onKeyEvent(html.KeyboardEvent event) {
    //print('_onKeyEvent:    $event');
  }
  
  /////////////////////////////////////////////////////////////////////////////
  ////  Mouse Events Handling  ////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  
  void _onMouseEvent(html.MouseEvent event) {
    //print('_onMouseEvent:    $event');
  }
  
  void _onMouseWheelEvent(html.WheelEvent event) {
    //print('_onMouseWheelEvent:    $event');
  }
  
  /////////////////////////////////////////////////////////////////////////////
  //// Size Handling  /////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  bool _sizeIsDirty = false;
  
  void _onResize(arg) {
    if (_rawContext == null) return;
    print('_onResize:    $arg');
    _sizeIsDirty = true;
  }
  
  int _width = 0;
  /// The width of the WebGL element.
  int get width => _width;
  
  int _height = 0;
  /// The height of the WebGL element.
  int get height => _height;
  
  void _updateSize() {
    _width = canvas.width;
    _height = canvas.height;
    _rawContext.viewport(0, 0, _width, _height);
    _sizeIsDirty = false;
    
    final length = _objects.length;
    for (int index = 0; index < _objects.length; index++)
      _objects[index].setGraphicsSize(_width, _height);
  }
  
  /////////////////////////////////////////////////////////////////////////////
  //// Background Color Handling  /////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////

  // Keep backgroundColor as [int] since upload is usually only called once.
  int _backgroundColor = 0xFF000000;
  
  /// The background color of the context.
  int get backgroundColor => _backgroundColor;
  
  void set backgroundColor(int value) {
    _backgroundColor = value;
    if (_rawContext != null)
      _uploadBackgroundColor();
  }
  
  void _uploadBackgroundColor() {
    _rawContext.clearColor(
        RGBA.getRedChannel(_backgroundColor),
        RGBA.getGreenChannel(_backgroundColor),
        RGBA.getBlueChannel(_backgroundColor),
        RGBA.getAlphaChannel(_backgroundColor));
  }
  
  /////////////////////////////////////////////////////////////////////////////
  //// Blend Mode Handling  ///////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  BlendMode _blendMode;
  /// The blend mode.
  BlendMode get blendMode => _blendMode;
  void set blendMode(BlendMode value) {
    if (value == _blendMode) return;
    _blendMode = value;
    _rawContext.blendFunc(gl.ONE, gl.ONE_MINUS_SRC_ALPHA);
  }
  
  /////////////////////////////////////////////////////////////////////////////
  //// Current Program Handling  //////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  GLProgram _activeProgram;
  
  void _setActiveProgram(GLProgram program) {
    if (! identical(program, _activeProgram)) {
      if (_activeProgram != null)
        _activeProgram._deactivate();
      _activeProgram = program;
    }
  }
  
  void flush() {
    if (_activeProgram != null) _activeProgram.flush();
  }
  
  /////////////////////////////////////////////////////////////////////////////
  //// Texture Handling  //////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  _GLTextureRoot _activeTexture;
  
  void _setActiveTexture(_GLTextureRoot texture) {
    if (! identical(texture, _activeTexture)) {
      if (_activeProgram != null)
        _activeProgram.flush();
      if (_activeTexture != null)
        _activeTexture._activated = false;
      _activeTexture = texture;
    }
  }
  
  /////////////////////////////////////////////////////////////////////////////
  //// Texture Methods  ///////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  
  GLTexture uploadTextureImage(html.ImageElement image) =>
      new _GLTextureRoot.fromImage(this, image);
  
}
