import 'package:canarslan_website/models/pointer_event_details.dart';
import 'dart:html' as html;

class JsBridgeService {
  late html.IFrameElement _iframeElement;

  void setIframeElement(html.IFrameElement element) {
    _iframeElement = element;
  }

  String _generateCopyScript() {
    return '''
      (function() {
        const selection = window.getSelection();
        const selectedText = selection.toString();
        if (selectedText) {
          try {
            navigator.clipboard.writeText(selectedText).then(() => {
              console.log('Copied with clipboard API');
            }).catch(() => {
              const textArea = document.createElement('textarea');
              textArea.value = selectedText;
              document.body.appendChild(textArea);
              document.execCommand('copy');
              document.body.removeChild(textArea);
              console.log('Copied with execCommand');
            });
          } catch (e) {
            console.error('Copy failed:', e);
          }
        }
      })();
    ''';
  }

  String _generatePointerEventScript(PointerEventDetails details) {
    return '''
      (function() {
        const asciiElement = document.getElementById('ascii');
        if (asciiElement) {
          const eventInit = {
            bubbles: true,
            cancelable: true,
            view: window,
            detail: 1,
            screenX: ${details.position.dx},
            screenY: ${details.position.dy},
            clientX: ${details.localPosition.dx},
            clientY: ${details.localPosition.dy},
            ctrlKey: false,
            altKey: false,
            shiftKey: false,
            metaKey: false,
            button: ${details.buttons - 1},
            buttons: ${details.buttons},
            relatedTarget: null,
          };

          const mouseEvent = new MouseEvent('${details.eventType}', eventInit);
          if ('${details.eventType}' === 'mousedown') {
            const range = document.createRange();
            const selection = window.getSelection();
            if (selection) {
              selection.removeAllRanges();
              selection.addRange(range);
            }
          }
          asciiElement.dispatchEvent(mouseEvent);
          
          if (${details.isPointerDown} && '${details.eventType}' === 'mousemove') {
            const selection = window.getSelection();
            if (selection && selection.rangeCount > 0) {
              const range = selection.getRangeAt(0);
              const newPosition = document.caretRangeFromPoint(
                ${details.localPosition.dx}, 
                ${details.localPosition.dy}
              );
              if (newPosition) {
                range.setEnd(newPosition.startContainer, newPosition.startOffset);
                selection.removeAllRanges();
                selection.addRange(range);
              }
            }
          }
        }
      })();
    ''';
  }

  void handleCopy() {
    if (_iframeElement.contentWindow != null) {
      final js = _generateCopyScript();
      _iframeElement.contentWindow?.postMessage(js, '*');
    }
  }

  void dispatchPointerEvent(PointerEventDetails details) {
    if (_iframeElement.contentWindow != null) {
      final js = _generatePointerEventScript(details);
      _iframeElement.contentWindow?.postMessage(js, '*');
    }
  }
}
