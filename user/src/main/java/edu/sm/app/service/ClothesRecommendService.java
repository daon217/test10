package edu.sm.app.service;

import edu.sm.app.dto.ClothesRecommendResult;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import javax.imageio.ImageIO;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.util.List;
import java.util.Locale;

/**
 * 서비스가 외부 모델 없이도 동작하도록, 업로드된 반려동물 전신 사진에서
 * 간단한 치수 추정과 컬러 팔레트 산출을 수행합니다.
 */
@Service
@Slf4j
public class ClothesRecommendService {

    private static final String PLACEHOLDER_IMAGE = "/images/virtual-fitting-placeholder.png";

    public ClothesRecommendResult analyzeAndRecommend(MultipartFile attach) {
        ClothesRecommendResult fallback = ClothesRecommendResult.builder()
                .animalType("분석 실패")
                .backLength("N/A")
                .chestGirth("N/A")
                .neckGirth("N/A")
                .recommendedSize("N/A")
                .clothingType("N/A")
                .colorAnalysis("이미지 분석에 실패했습니다. 사진이 맞는지 확인 후 다시 시도해주세요.")
                .fittingImageDesc("AI가 가상 피팅 이미지를 준비하지 못했습니다.")
                .fittingImageUrl(PLACEHOLDER_IMAGE)
                .colorPalette(List.of("#9aa5b1", "#c9d1d9", "#6b7280"))
                .build();

        try {
            if (attach == null || attach.isEmpty()) {
                log.warn("Empty attachment received for clothes recommendation.");
                return fallback;
            }

            BufferedImage image = ImageIO.read(attach.getInputStream());
            if (image == null) {
                log.warn("Invalid image data received for clothes recommendation.");
                return fallback;
            }

            int width = image.getWidth();
            int height = image.getHeight();
            double ratio = (double) height / Math.max(1, width);

            double roughCm = Math.min(80, Math.max(25, (height + width) / 12.0));
            double backLength = Math.round(roughCm * (ratio > 1.2 ? 0.7 : 0.6));
            double chest = Math.round(backLength * 1.25);
            double neck = Math.round(backLength * 0.55);

            String size;
            if (backLength < 28) size = "S";
            else if (backLength < 38) size = "M";
            else if (backLength < 50) size = "L";
            else size = "XL";

            String animalType = ratio > 1.2 ? "중형견" : "소형견/고양이";
            String clothingType = ratio > 1.4 ? "하네스가 잘 어울리는 원마일웨어" : "활동성 높은 티셔츠";

            Color averageColor = extractAverageColor(image);
            String hex = toHex(averageColor);
            List<String> palette = List.of(hex, shiftColor(averageColor, 18), shiftColor(averageColor, -18));
            String colorName = describeColor(averageColor);
            String colorAnalysis = String.format("주요 털 색상은 %s 계열이에요. %s 톤의 의류와 가장 잘 어울리며, 포인트 컬러로 %s를 추천합니다.",
                    colorName, colorName, palette.get(2));

            String fittingDesc = String.format(Locale.US,
                    "Studio style photo of a %s wearing a %s (%s palette), soft lighting, minimal background, realistic fur texture",
                    animalType, clothingType, colorName);

            return ClothesRecommendResult.builder()
                    .animalType(animalType)
                    .backLength(String.format("%.0f cm (추정)", backLength))
                    .chestGirth(String.format("%.0f cm (추정)", chest))
                    .neckGirth(String.format("%.0f cm (추정)", neck))
                    .recommendedSize(size)
                    .clothingType(clothingType)
                    .colorAnalysis(colorAnalysis)
                    .fittingImageDesc(fittingDesc)
                    .fittingImageUrl(PLACEHOLDER_IMAGE)
                    .colorPalette(palette)
                    .build();
        } catch (IOException e) {
            log.error("Failed to analyze image for clothes recommendation", e);
            return fallback;
        }
    }

    private Color extractAverageColor(BufferedImage image) {
        long r = 0, g = 0, b = 0;
        int samples = 0;
        int stepX = Math.max(1, image.getWidth() / 60);
        int stepY = Math.max(1, image.getHeight() / 60);

        for (int y = 0; y < image.getHeight(); y += stepY) {
            for (int x = 0; x < image.getWidth(); x += stepX) {
                int rgb = image.getRGB(x, y);
                Color c = new Color(rgb, true);
                r += c.getRed();
                g += c.getGreen();
                b += c.getBlue();
                samples++;
            }
        }

        if (samples == 0) return new Color(180, 180, 180);
        return new Color((int) (r / samples), (int) (g / samples), (int) (b / samples));
    }

    private String describeColor(Color color) {
        float[] hsb = Color.RGBtoHSB(color.getRed(), color.getGreen(), color.getBlue(), null);
        float hue = hsb[0] * 360;
        float brightness = hsb[2];

        if (brightness < 0.25) return "딥 톤";
        if (brightness > 0.8) return "라이트 톤";

        if (hue < 30 || hue >= 330) return "웜 레드/브라운";
        if (hue < 90) return "옐로/그린";
        if (hue < 150) return "그린";
        if (hue < 210) return "민트/블루";
        if (hue < 270) return "네이비/퍼플";
        return "바이올렛";
    }

    private String toHex(Color color) {
        return String.format("#%02x%02x%02x", color.getRed(), color.getGreen(), color.getBlue());
    }

    private String shiftColor(Color base, int delta) {
        int r = clamp(base.getRed() + delta);
        int g = clamp(base.getGreen() + delta);
        int b = clamp(base.getBlue() + delta);
        return toHex(new Color(r, g, b));
    }

    private int clamp(int value) {
        return Math.max(0, Math.min(255, value));
    }
}