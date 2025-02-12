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
        const charHeight = 8; // 12'den 8'e değiştirildi

        // 8/12 = 2/3 oranı ile çarparak düzeltme yapıyoruz
        const heightRatio = 8 / 12;
        console.log(window.innerWidth);
        const screenRatio = (window.innerWidth * 1.82 * heightRatio) / window.innerHeight;

        const cols = Math.floor((window.innerWidth * 1.82) / charWidth);
        const rows = Math.floor(window.innerHeight / charHeight);

        this.noiseOffsets = Array(rows).fill().map(() =>
            Array(cols).fill().map(() => Math.random() * 0.2)
        );

        this.canvas.width = cols;
        this.canvas.height = rows;
        this.ascii.style.fontSize = `${charWidth}px`;
        this.ascii.style.lineHeight = `${charHeight}px`;
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