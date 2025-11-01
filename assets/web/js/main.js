document.addEventListener('DOMContentLoaded', () => {
    const video = document.getElementById('video');
    const processor = new VideoProcessor();
    let hasStarted = false;

    const startVideo = () => {
        if (hasStarted) return;
        hasStarted = true;
        processor.processFrame(video);
        video.play().catch(err => console.log('Video play failed:', err));
    };

    // Try multiple events for iOS Safari compatibility
    video.addEventListener('loadeddata', startVideo);
    video.addEventListener('canplay', startVideo);
    video.addEventListener('canplaythrough', startVideo);

    // Fallback: try to start after a short delay
    setTimeout(() => {
        if (!hasStarted && video.readyState >= 2) {
            startVideo();
        }
    }, 100);

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