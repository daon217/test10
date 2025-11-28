package edu.sm.config;

import com.graphhopper.GraphHopper;
import com.graphhopper.config.CHProfile;
import com.graphhopper.config.Profile;
import com.graphhopper.util.CustomModel;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class GraphHopperConfig {

    @Value("${map.osm-file}")
    private String osmFile;

    @Value("${map.graph-cache}")
    private String graphCacheDir;

    @Bean
    public GraphHopper graphHopper() {
        GraphHopper hopper = new GraphHopper();

        // OSM 파일, 캐시 디렉터리
        hopper.setOSMFile(osmFile);
        hopper.setGraphHopperLocation(graphCacheDir);

        // ★ GraphHopper 8에서는 fastest/shortest 대신 custom 사용 권장
        CustomModel cm = new CustomModel();
        cm.setDistanceInfluence(70.0); // 거리 짧은 쪽을 더 선호하게

        Profile footProfile = new Profile("foot")
                .setVehicle("foot")
                .setWeighting("custom")
                .setCustomModel(cm);

        hopper.setProfiles(footProfile);
        hopper.getCHPreparationHandler()
                .setCHProfiles(new CHProfile("foot"));

        // 그래프 생성 또는 로드
        hopper.importOrLoad();

        return hopper;
    }
}
