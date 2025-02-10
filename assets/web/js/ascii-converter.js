class AsciiConverter {
    static ASCII_CHARS = " .`-_':,;^=+/\"|)\\<>)v?}{[]r*x!Licv#zsJ7(t1faleng2345STX%@$&YVURWDBQKHNM";

    static getAsciiChar(brightness) {
        return this.ASCII_CHARS[Math.floor(brightness * (this.ASCII_CHARS.length - 1))];
    }

    static convertPixelsToAscii(pixels, cols, rows, animationProgress = 1, screenRatio = 1, noiseOffsets = []) {
        let asciiImage = '';
        const centerX = Math.floor(cols / 2);
        const centerY = Math.floor(rows / 2);

        const maxRadius = Math.sqrt(Math.pow(cols / screenRatio, 2) + Math.pow(rows, 2)) / 2;
        const currentRadius = maxRadius * animationProgress;

        const rowOffsets = Array(rows).fill().map(() =>
            Math.sin(animationProgress * Math.PI) * (Math.random() - 0.5) * 2
        );

        for (let i = 0; i < rows; i++) {
            const rowShift = Math.floor(rowOffsets[i] * 2);

            for (let j = 0; j < cols; j++) {
                const idx = (i * cols + j) * 4;

                const adjustedX = j + rowShift;
                const noiseOffset = noiseOffsets[i]?.[j] || 0;
                const distance = Math.sqrt(
                    Math.pow((adjustedX - centerX) / screenRatio, 2) +
                    Math.pow(i - centerY, 2)
                ) + (noiseOffset * maxRadius * 0.1);

                const randomThreshold = Math.random() * 0.1 * animationProgress;

                if (distance <= currentRadius + (randomThreshold * maxRadius)) {
                    const brightness = (pixels[idx] + pixels[idx + 1] + pixels[idx + 2]) / 3 / 255;
                    asciiImage += this.getAsciiChar(brightness);
                } else {
                    asciiImage += ' ';
                }
            }
            asciiImage += '\n';
        }
        return asciiImage;
    }
}