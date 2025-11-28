package edu.sm.app.service;

import com.graphhopper.GHRequest;
import com.graphhopper.GHResponse;
import com.graphhopper.GraphHopper;
import com.graphhopper.ResponsePath;
import com.graphhopper.util.PointList;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class MapRouteService {

    private final GraphHopper hopper;

    public MapRouteService(GraphHopper hopper) {
        this.hopper = hopper;
    }

    /* =========================================================
     *  공통: "모양의 맨 아래 점"이 centerLat/centerLon 이 되도록 정렬
     *  - 가장 위가 아니라 가장 남쪽(lat 최소) 점을 찾는다
     *  - 그 점이 실제 centerLat/centerLon 에 오도록 전체 모양을 평행이동
     *  - 그 점이 0번 인덱스가 되도록 시계방향으로 회전
     *  => 더 이상 모양 중심을 억지로 지나가지 않음
     * ========================================================= */
    private List<GeoPoint> alignBottomToUser(List<GeoPoint> points,
                                             double centerLat,
                                             double centerLon) {
        if (points == null || points.isEmpty()) return points;

        // 1) 가장 남쪽(위도 최소)인 점 찾기 = 모양의 "맨 아래" 점
        int bottomIdx = 0;
        double minLat = Double.MAX_VALUE;
        for (int i = 0; i < points.size(); i++) {
            GeoPoint p = points.get(i);
            if (p.lat < minLat) {
                minLat = p.lat;
                bottomIdx = i;
            }
        }

        // 2) 그 점이 정확히 centerLat/centerLon 에 오도록 전체 평행이동
        GeoPoint bottom = points.get(bottomIdx);
        double dLat = centerLat - bottom.lat;
        double dLon = centerLon - bottom.lon;

        List<GeoPoint> shifted = new ArrayList<>();
        for (GeoPoint p : points) {
            shifted.add(new GeoPoint(p.lat + dLat, p.lon + dLon));
        }

        // 3) 시작 인덱스를 bottomIdx 로 회전 (0번이 모양 맨 아래)
        List<GeoPoint> rotated = new ArrayList<>();
        for (int i = 0; i < shifted.size(); i++) {
            rotated.add(shifted.get((bottomIdx + i) % shifted.size()));
        }

        return rotated;
    }

    // ===== 공개 API: sizeKm 기준 도형 생성 =====
    public ShapeRouteResponse getShapeRoute(String type,
                                            double centerLat,
                                            double centerLon,
                                            double sizeKm) {

        if (sizeKm <= 0) sizeKm = 1.2;

        String shape = (type == null ? "heart" : type.toLowerCase());

        List<GeoPoint> basePoints;
        switch (shape) {
            case "heart":
                basePoints = generateHeartPoints(centerLat, centerLon, sizeKm);
                break;
            case "circle":
            case "round":
                basePoints = generateCirclePoints(centerLat, centerLon, sizeKm);
                break;
            case "square":    // 백엔드 직접 호출용
            case "nemo":      // JSP 쪽에서 보낼 문자열
                basePoints = generatePolygonPoints(centerLat, centerLon, sizeKm,
                        4, Math.toRadians(45));   // ♦ 모양(45도 회전)
                break;
            case "triangle":
            case "semo":
                basePoints = generatePolygonPoints(centerLat, centerLon, sizeKm,
                        3, Math.toRadians(-90));  // 꼭짓점이 위로 향하는 정삼각형
                break;
            default:
                basePoints = generateCirclePoints(centerLat, centerLon, sizeKm);
                break;
        }

        return buildRouteFromBasePoints(basePoints);
    }

    // ===== 공개 API: targetKm 기준 자동 튜닝 =====
    public ShapeRouteResponse getShapeRouteByTargetKm(String type,
                                                      double centerLat,
                                                      double centerLon,
                                                      double targetKm) {
        if (targetKm <= 0) {
            targetKm = 4.0;
        }

        double sizeKm = targetKm;  // 처음엔 목표 거리로 시작
        ShapeRouteResponse best = null;
        double bestDiff = Double.MAX_VALUE;

        for (int i = 0; i < 6; i++) {
            ShapeRouteResponse res = getShapeRoute(type, centerLat, centerLon, sizeKm);
            if (res.getDistanceKm() <= 0) break;

            double diff = Math.abs(res.getDistanceKm() - targetKm);
            if (diff < bestDiff) {
                bestDiff = diff;
                best = res;
            }

            double ratio = targetKm / res.getDistanceKm();
            sizeKm = sizeKm * ratio;
        }

        return best;
    }

    // (현재는 안 쓰지만 남겨둔 후보 중심 생성)
    private List<LatLon> buildCandidateCenters(double userLat,
                                               double userLon,
                                               double targetKm,
                                               int candidateCount) {

        List<LatLon> list = new ArrayList<>();

        double radiusKm = targetKm / 3.0;
        double kmToLat = 1.0 / 111.0;
        double kmToLon = 1.0 / (111.0 * Math.cos(Math.toRadians(userLat)));

        double[][] dirs = {
                { 0,  1},  // N
                { 1,  1},  // NE
                { 1,  0},  // E
                { 1, -1},  // SE
                { 0, -1},  // S
                {-1, -1},  // SW
                {-1,  0},  // W
                {-1,  1}   // NW
        };

        for (int i = 0; i < dirs.length && list.size() < candidateCount; i++) {
            double dxKm = dirs[i][0] * radiusKm;
            double dyKm = dirs[i][1] * radiusKm;

            double lat = userLat + dyKm * kmToLat;
            double lon = userLon + dxKm * kmToLon;

            list.add(new LatLon(lat, lon));
        }

        if (list.size() < candidateCount) {
            list.add(new LatLon(userLat, userLon));
        }

        return list;
    }

    // ===== GraphHopper에 실제 경로 요청 =====
    private ShapeRouteResponse buildRouteFromBasePoints(List<GeoPoint> basePoints) {
        List<GeoPoint> routePoints = new ArrayList<>();
        double totalDistanceMeters = 0.0;

        for (int i = 0; i < basePoints.size(); i++) {
            GeoPoint a = basePoints.get(i);
            GeoPoint b = basePoints.get((i + 1) % basePoints.size()); // 마지막→처음

            GHRequest req = new GHRequest(a.lat, a.lon, b.lat, b.lon)
                    .setProfile("foot");

            GHResponse res = hopper.route(req);
            if (res.hasErrors()) {
                continue;
            }

            ResponsePath path = res.getBest();
            PointList pts = path.getPoints();

            totalDistanceMeters += path.getDistance();

            for (int idx = (i == 0 ? 0 : 1); idx < pts.size(); idx++) {
                routePoints.add(new GeoPoint(pts.getLat(idx), pts.getLon(idx)));
            }
        }

        double totalKm = totalDistanceMeters / 1000.0;
        double avgSpeedKmh = 4.0; // 도보
        double estimatedMinutes = (totalKm / avgSpeedKmh) * 60.0;

        return new ShapeRouteResponse(routePoints, totalKm, estimatedMinutes);
    }

    // ===== 하트 모양 =====
    private List<GeoPoint> generateHeartPoints(double centerLat,
                                               double centerLon,
                                               double sizeKm) {

        List<GeoPoint> list = new ArrayList<>();

        double radiusKm = sizeKm * 0.7;
        double kmToLat = 1.0 / 111.0;

        double scale = radiusKm * kmToLat * 0.06;

        double angle = Math.toRadians(-15.0);
        double cosA = Math.cos(angle);
        double sinA = Math.sin(angle);

        int N = 40;

        for (int i = 0; i < N; i++) {
            double t = 2.0 * Math.PI * i / N;

            double x = 16 * Math.pow(Math.sin(t), 3);
            double y = 13 * Math.cos(t) - 5 * Math.cos(2 * t)
                    - 2 * Math.cos(3 * t) - Math.cos(4 * t);

            x *= scale;
            y *= scale;

            double rx = x * cosA - y * sinA;
            double ry = x * sinA + y * cosA;

            double lat = centerLat + ry;
            double lon = centerLon + rx / Math.cos(Math.toRadians(centerLat));

            list.add(new GeoPoint(lat, lon));
        }

        // ★ 하트 모양도 맨 아래 점이 내 위치가 되도록 정렬
        return alignBottomToUser(list, centerLat, centerLon);
    }

    // ===== 정다각형(네모/세모 등) 공통 =====
    private List<GeoPoint> generatePolygonPoints(double centerLat,
                                                 double centerLon,
                                                 double sizeKm,
                                                 int sides,
                                                 double rotationRad) {

        List<GeoPoint> list = new ArrayList<>();

        double radiusKm = sizeKm * 0.6;

        double kmToLat = 1.0 / 111.0;
        double kmToLon = 1.0 / (111.0 * Math.cos(Math.toRadians(centerLat)));

        double[] vx = new double[sides];
        double[] vy = new double[sides];
        for (int i = 0; i < sides; i++) {
            double t = 2.0 * Math.PI * i / sides + rotationRad;
            vx[i] = radiusKm * Math.cos(t);
            vy[i] = radiusKm * Math.sin(t);
        }

        int segPerSide = 12; // 한 변당 12개 포인트

        for (int i = 0; i < sides; i++) {
            int j = (i + 1) % sides;

            for (int s = 0; s < segPerSide; s++) {
                double ratio = (double) s / segPerSide;

                double xKm = vx[i] + (vx[j] - vx[i]) * ratio;
                double yKm = vy[i] + (vy[j] - vy[i]) * ratio;

                double lat = centerLat + yKm * kmToLat;
                double lon = centerLon + xKm * kmToLon;

                list.add(new GeoPoint(lat, lon));
            }
        }

        // ★ 네모/세모도 맨 아래 점이 내 위치가 되도록 정렬
        return alignBottomToUser(list, centerLat, centerLon);
    }

    // ===== 원 모양 =====
    private List<GeoPoint> generateCirclePoints(double centerLat,
                                                double centerLon,
                                                double sizeKm) {

        List<GeoPoint> list = new ArrayList<>();

        double radiusKm = sizeKm * 0.6;
        double kmToLat = 1.0 / 111.0;
        double kmToLon = 1.0 / (111.0 * Math.cos(Math.toRadians(centerLat)));

        int N = 32;

        for (int i = 0; i < N; i++) {
            double t = 2.0 * Math.PI * i / N;
            double dxKm = radiusKm * Math.cos(t);
            double dyKm = radiusKm * Math.sin(t);

            double lat = centerLat + dyKm * kmToLat;
            double lon = centerLon + dxKm * kmToLon;

            list.add(new GeoPoint(lat, lon));
        }

        // ★ 원도 맨 아래 점이 내 위치
        return alignBottomToUser(list, centerLat, centerLon);
    }

    // ===== DTO =====
    @Data
    @AllArgsConstructor
    @NoArgsConstructor
    public static class LatLon {
        private double lat;
        private double lon;
    }

    @Data
    @AllArgsConstructor
    @NoArgsConstructor
    public static class GeoPoint {
        private double lat;
        private double lon;
    }

    @Data
    @AllArgsConstructor
    @NoArgsConstructor
    public static class ShapeRouteResponse {
        private List<GeoPoint> points;
        private double distanceKm;
        private double estimatedMinutes;
    }
}
