import 'dart:js' as js;

import 'package:flutter/material.dart';
import 'package:Keioboys/consts.dart';
import 'package:universal_html/html.dart' as html;

import 'package:Keioboys/Widgets/fake_ui.dart' if (dart.library.html) 'dart:ui'
    as ui;

class CropperScreen extends StatefulWidget {
  final String imagePath;
  final double ratio;

//  const CropperScreen(this.imagePath, {Key key}) : super(key: key);
  const CropperScreen({this.imagePath, this.ratio, Key key}) : super(key: key);

  @override
  _CropperScreenState createState() => _CropperScreenState();
}

class _CropperScreenState extends State<CropperScreen> {
  html.DivElement _element;
  js.JsObject _viewer;
  @override
  void initState() {
    super.initState();
    _element = html.DivElement();
    var css = getCropperCss();
    _element.append(css);

    var _imageElement = html.ImageElement()
      ..src = widget.imagePath
      ..style.maxWidth = '100%'
      ..style.display = 'block';
    _element.append(_imageElement);
    _viewer = js.JsObject(js.context['Cropper'], [
      _imageElement,
      js.JsObject.jsify({
        'aspectRatio': widget.ratio,
        'dragMode': 'move',
        'cropBoxResizable': false,
        'toggleDragModeOnDblclick': false,
      })
    ]);
    ui.platformViewRegistry
        .registerViewFactory(widget.imagePath, (int viewId) => _element);
  }

  getCropperCss() {
    var css = html.StyleElement();
    css.appendText(
        '.cropper-container{direction:ltr;font-size:0;line-height:0;position:relative;-ms-touch-action:none;touch-action:none;-webkit-user-select:none;-moz-user-select:none;-ms-user-select:none;user-select:none}.cropper-container img{display:block;height:100%;image-orientation:0deg;max-height:none!important;max-width:none!important;min-height:0!important;min-width:0!important;width:100%}.cropper-canvas,.cropper-crop-box,.cropper-drag-box,.cropper-modal,.cropper-wrap-box{bottom:0;left:0;position:absolute;right:0;top:0}.cropper-canvas,.cropper-wrap-box{overflow:hidden}.cropper-drag-box{background-color:#fff;opacity:0}.cropper-modal{background-color:#000;opacity:.5}.cropper-view-box{display:block;height:100%;outline:1px solid #f16;outline-color:rgba(51,153,255,.75);overflow:hidden;width:100%}.cropper-dashed{border:0 dashed #eee;display:block;opacity:.5;position:absolute}.cropper-dashed.dashed-h{border-bottom-width:1px;border-top-width:1px;height:33.33333%;left:0;top:33.33333%;width:100%}.cropper-dashed.dashed-v{border-left-width:1px;border-right-width:1px;height:100%;left:33.33333%;top:0;width:33.33333%}.cropper-center{display:block;height:0;left:50%;opacity:.75;position:absolute;top:50%;width:0}.cropper-center:after,.cropper-center:before{background-color:#eee;content:" ";display:block;position:absolute}.cropper-center:before{height:1px;left:-3px;top:0;width:7px}.cropper-center:after{height:7px;left:0;top:-3px;width:1px}.cropper-face,.cropper-line,.cropper-point{display:block;height:100%;opacity:.1;position:absolute;width:100%}.cropper-face{background-color:#fff;left:0;top:0}.cropper-line{background-color:#f16}.cropper-line.line-e{cursor:ew-resize;right:-3px;top:0;width:5px}.cropper-line.line-n{cursor:ns-resize;height:5px;left:0;top:-3px}.cropper-line.line-w{cursor:ew-resize;left:-3px;top:0;width:5px}.cropper-line.line-s{bottom:-3px;cursor:ns-resize;height:5px;left:0}.cropper-point{background-color:#f16;height:5px;opacity:.75;width:5px}.cropper-point.point-e{cursor:ew-resize;margin-top:-3px;right:-3px;top:50%}.cropper-point.point-n{cursor:ns-resize;left:50%;margin-left:-3px;top:-3px}.cropper-point.point-w{cursor:ew-resize;left:-3px;margin-top:-3px;top:50%}.cropper-point.point-s{bottom:-3px;cursor:s-resize;left:50%;margin-left:-3px}.cropper-point.point-ne{cursor:nesw-resize;right:-3px;top:-3px}.cropper-point.point-nw{cursor:nwse-resize;left:-3px;top:-3px}.cropper-point.point-sw{bottom:-3px;cursor:nesw-resize;left:-3px}.cropper-point.point-se{bottom:-3px;cursor:nwse-resize;height:20px;opacity:1;right:-3px;width:20px}@media (min-width:768px){.cropper-point.point-se{height:15px;width:15px}}@media (min-width:992px){.cropper-point.point-se{height:10px;width:10px}}@media (min-width:1200px){.cropper-point.point-se{height:5px;opacity:.75;width:5px}}.cropper-point.point-se:before{background-color:#f16;bottom:-50%;content:" ";display:block;height:200%;opacity:0;position:absolute;right:-50%;width:200%}.cropper-invisible{opacity:0}.cropper-bg{background-image:url("data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQAQMAAAAlPW0iAAAAA3NCSVQICAjb4U/gAAAABlBMVEXMzMz////TjRV2AAAACXBIWXMAAArrAAAK6wGCiw1aAAAAHHRFWHRTb2Z0d2FyZQBBZG9iZSBGaXJld29ya3MgQ1M26LyyjAAAABFJREFUCJlj+M/AgBVhF/0PAH6/D/HkDxOGAAAAAElFTkSuQmCC")}.cropper-hide{display:block;height:0;position:absolute;width:0}.cropper-hidden{display:none!important}.cropper-move{cursor:move}.cropper-crop{cursor:crosshair}.cropper-disabled .cropper-drag-box,.cropper-disabled .cropper-face,.cropper-disabled .cropper-line,.cropper-disabled .cropper-point{cursor:not-allowed}');
    return css;
  }

  Future<html.Blob> result_data() async {
    var result = _viewer.callMethod('getCroppedCanvas') as html.CanvasElement;
    return result.toBlob();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        toolbarHeight: 80,
        title: Text(
          'トリミング',
          style: TextStyle(
            color: pink,
          ),
        ),
        backgroundColor: white,
        iconTheme: IconThemeData(
          color: pink,
        ),
        actions: [
          FlatButton.icon(
            icon: Icon(
              Icons.crop,
              color: pink,
            ),
            label: Text(
              'OK',
              style: TextStyle(
                color: pink,
              ),
            ),
            onPressed: () async {
              Navigator.pop(context, await result_data());
            },
          )
        ],
      ),
      body: Center(
        child: HtmlElementView(
          key: ValueKey(widget.imagePath),
          viewType: widget.imagePath,
        ),
      ),
    );
  }
}
