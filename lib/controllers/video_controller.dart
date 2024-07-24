import 'dart:ui' as ui;
import 'dart:html' as html;

void registerVideoElement() {
  // Registering the video element with a unique view type
  // ignore: undefined_prefixed_name
  ui.platformViewRegistry.registerViewFactory(
    'videoElement',
    (int viewId) {
      final video = html.VideoElement()
        ..src = 'assets/videos/caminhoes-pagina-inicial.mp4'
        ..style.border = 'none'
        ..autoplay = true
        ..loop = true
        ..muted = true
        ..style.objectFit =
            'cover' // Ensure the video covers the entire container
        ..style.width = '100%'
        ..style.height = '100%';
      return video;
    },
  );
}
