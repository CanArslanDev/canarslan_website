document.addEventListener('DOMContentLoaded', () => {
    const video = document.getElementById('video');
    const processor = new VideoProcessor();

    video.addEventListener('loadeddata', () => {
        processor.processFrame(video);
        video.play();
    });
    window.addEventListener('message', function (event) {
        if (event.data && event.data.type === 'mouseEvent') {
            const mouseEvent = new MouseEvent(event.data.eventType, {
                bubbles: true,
                clientX: event.data.x,
                clientY: event.data.y,
                buttons: event.data.buttons
            });
            document.dispatchEvent(mouseEvent);
        }
    });
    window.addEventListener('resize', () => processor.resizeCanvas());

});

window.onmessage = function (event) {
    if (typeof event.data === 'string') {
        try {
            eval(event.data);
        } catch (e) {
            console.error('Script execution error:', e);
        }
    }
};