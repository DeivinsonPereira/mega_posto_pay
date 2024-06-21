package com.example.megga_posto_mobile;

import android.graphics.Bitmap;
import java.util.function.Consumer;

public class BitmapProcessor {

    public static void processBitmapForPrint(Bitmap bitmap, Consumer<Bitmap> onPrintBitmap) {
        int currentY = 0;
        int currentBlock = 1;
        int blockHeight = 595;
        double blockCount = Math.ceil((double) bitmap.getHeight() / blockHeight);

        while (currentBlock <= blockCount) {
            int targetHeight;
            if (currentY + blockHeight > bitmap.getHeight()) {
                targetHeight = bitmap.getHeight() - currentY;
            } else {
                targetHeight = blockHeight;
            }

            onPrintBitmap.accept(Bitmap.createBitmap(bitmap, 0, currentY, bitmap.getWidth(), targetHeight));

            if (currentY + blockHeight > bitmap.getHeight()) {
                currentY = bitmap.getHeight() - currentY;
            } else {
                currentY += blockHeight;
            }

            currentBlock++;
        }
    }
}
