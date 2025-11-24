<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<style>
  .env-card {
    background: #fff; border-radius: 10px; padding: 20px;
    box-shadow: 0 0 15px rgba(0,0,0,0.1); margin-bottom: 20px;
    text-align: center; transition: 0.3s;
  }
  .env-card.active { border: 2px solid #3498db; } /* 작동 중일 때 테두리 강조 */
  .temp-val { font-size: 2.5rem; font-weight: bold; color: #333; }
  .hum-val { font-size: 1.5rem; color: #666; }
  .device-badge { font-size: 0.8rem; padding: 5px 8px; border-radius: 5px; color: #fff; margin: 2px; display: inline-block;}
  .bg-off { background-color: #d1d1d1; color: #fff; }
  .bg-cool { background-color: #3498db; } /* 에어컨 파랑 */
  .bg-heat { background-color: #e74c3c; } /* 히터 빨강 */
  .bg-humi { background-color: #2ecc71; } /* 가습기 초록 */
  .bg-dry { background-color: #f1c40f; }  /* 제습기 노랑 */
</style>

<div class="pd-ltr-20 xs-pd-20-10">
  <div class="min-height-200px">
    <div class="page-header">
      <div class="row">
        <div class="col-md-12 col-sm-12">
          <div class="title">
            <h4>AI 온습도 자동 제어 시스템</h4>
            <p>AI가 실시간으로 환경을 감지하여 냉난방기를 자동으로 조작합니다.</p>
          </div>
        </div>
      </div>
    </div>

    <div class="row" id="zone-container">
      <div class="col-12 text-center"><h3 class="text-muted">AI 시스템 연결 중...</h3></div>
    </div>
  </div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
  $(document).ready(function(){
    // 처음 로딩 시 실행
    loadEnvData();

    // 이후 1분(60000ms)마다 데이터 갱신
    setInterval(loadEnvData, 60000);
  });

  function loadEnvData() {
    $.ajax({
      url: '/api/env/zones',
      success: function(data) {
        let html = '';
        // 구역 번호순 정렬
        data.sort((a, b) => a.id - b.id);

        data.forEach(z => {
          // 소수점 1자리로 깔끔하게 표시
          let displayTemp = z.temp.toFixed(1);
          let displayHum = z.hum.toFixed(1);

          // ... (이하 배지 생성 및 HTML 코드는 이전과 동일) ...

          // 배지 코드 복붙용:
          let acTag = z.ac ? '<span class="device-badge bg-cool">에어컨 ON</span>' : '<span class="device-badge bg-off">에어컨 OFF</span>';
          let heaterTag = z.heater ? '<span class="device-badge bg-heat">히터 ON</span>' : '<span class="device-badge bg-off">히터 OFF</span>';
          let humTag = z.humidifier ? '<span class="device-badge bg-humi">가습기 ON</span>' : '<span class="device-badge bg-off">가습기 OFF</span>';
          let dehumTag = z.dehumidifier ? '<span class="device-badge bg-dry">제습기 ON</span>' : '<span class="device-badge bg-off">제습기 OFF</span>';
          let activeClass = (z.ac || z.heater || z.humidifier || z.dehumidifier) ? 'active' : '';

          html += `
                    <div class="col-xl-4 col-lg-4 col-md-6 col-sm-12">
                        <div class="env-card \${activeClass}">
                            <h4 class="mb-20">구역 \${z.id}</h4>
                            <div class="row align-items-center justify-content-center">
                                <div class="col-6">
                                    <span class="d-block">온도</span>
                                    <div class="temp-val">\${displayTemp}°C</div>
                                </div>
                                <div class="col-6">
                                    <span class="d-block">습도</span>
                                    <div class="hum-val">\${displayHum}%</div>
                                </div>
                            </div>
                            <div class="mt-3">
                                <div class="alert alert-secondary py-1" style="font-size:0.9rem;">
                                    \${z.msg}
                                </div>
                            </div>
                            <div class="mt-2">
                                <div>\${acTag} \${heaterTag}</div>
                                <div>\${humTag} \${dehumTag}</div>
                            </div>
                        </div>
                    </div>`;
        });
        $('#zone-container').html(html);
      }
    });
  }
</script>