class VideoProcessor {
    constructor() {
        this.canvas = document.getElementById('canvas');
        this.ctx = this.canvas.getContext('2d');
        this.ascii = document.getElementById('ascii');
        this.animationProgress = 0;
        this.animationStartTime = null;
        this.animationDuration = 1500;
        this.noiseOffsets = [];
    }

    resizeCanvas() {
        const charWidth = 6;
        const charHeight = 8;

        // Windows renders text slightly wider than macOS
        const widthMultiplier = navigator.userAgentData.platform.includes('Windows') ? 1.8 : 1.66;

        const cols = Math.floor((window.innerWidth * widthMultiplier) / charWidth);
        const rows = Math.floor(window.innerHeight / charHeight);

        const heightRatio = 8 / 12;
        const screenRatio = (window.innerWidth * widthMultiplier * heightRatio) / window.innerHeight;

        this.canvas.width = cols;
        this.canvas.height = rows;

        this.ascii.style.fontSize = `${charWidth}px`;
        this.ascii.style.lineHeight = `${charHeight}px`;

        this.noiseOffsets = Array(rows).fill().map(() =>
            Array(cols).fill().map(() => Math.random() * 0.2)
        );

        return { cols, rows, screenRatio };
    }

    processFrame(video) {
        const { cols, rows, screenRatio } = this.resizeCanvas();
        this.ctx.drawImage(video, 0, 0, cols, rows);
        const imageData = this.ctx.getImageData(0, 0, cols, rows);

        if (!this.animationStartTime) {
            this.animationStartTime = performance.now();
        }

        const currentTime = performance.now();
        const elapsed = currentTime - this.animationStartTime;
        this.animationProgress = Math.min(elapsed / this.animationDuration, 1);

        const asciiImage = AsciiConverter.convertPixelsToAscii(
            imageData.data,
            cols,
            rows,
            this.animationProgress,
            screenRatio,
            this.noiseOffsets
        );

        this.ascii.textContent = asciiImage;
        requestAnimationFrame(() => this.processFrame(video));
    }
}