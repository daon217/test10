/**
 * 향상된 스크롤 비디오 컨트롤
 * 여러 효과를 조합하여 사용
 */

function initEnhancedScrollVideo() {
    const video = document.getElementById('scroll-video');
    const videoContainer = document.getElementById('video-background');

    if (!video) return;

    let isVideoReady = false;

    // 비디오 메타데이터 로드
    video.addEventListener('loadedmetadata', function() {
        isVideoReady = true;
        const videoDuration = video.duration;

        // 초기 상태 설정
        video.currentTime = 0;

        // 스크롤 이벤트 - 메인 효과
        let ticking = false;

        window.addEventListener('scroll', function() {
            if (!ticking && isVideoReady) {
                window.requestAnimationFrame(function() {
                    updateVideoEffects(video, videoDuration);
                    ticking = false;
                });
                ticking = true;
            }
        }, { passive: true });
    });

    // 비디오 로드 시작
    video.load();

    // 에러 처리
    video.addEventListener('error', function(e) {
        console.error('Video loading error:', e);
        if (videoContainer) {
            videoContainer.style.background = 'linear-gradient(135deg, rgba(255, 227, 227, 0.85) 0%, rgba(227, 255, 249, 0.85) 100%)';
        }
    });
}

function updateVideoEffects(video, duration) {
    const scrollY = window.scrollY;
    const maxScroll = Math.max(
            document.documentElement.scrollHeight - window.innerHeight,
            1000
    );

    // 전체 진행률 (0~1)
    const progress = Math.min(scrollY / maxScroll, 1);

    // 1. 비디오 타임라인 업데이트 (강아지가 점점 다가옴)
    video.currentTime = progress * duration;

    // 2. 줌 & 스케일 효과 (점점 커짐)
    const scale = 1 + (progress * 0.3); // 1배 → 1.3배

    // 3. 투명도 조절 (점점 선명해짐)
    const opacity = 0.4 + (progress * 0.3); // 0.4 → 0.7

    // 4. 블러 효과 (흐릿 → 선명)
    const blur = Math.max(8 - (progress * 8), 0); // 8px → 0px

    // 효과 적용
    video.style.transform = `translate(-50%, -50%) scale(${scale})`;
    video.style.opacity = opacity;
    video.style.filter = `blur(${blur}px)`;
    video.style.transition = 'none'; // 스크롤 시 부드러운 전환
}

// 페이지 로드 시 초기화
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initEnhancedScrollVideo);
} else {
    initEnhancedScrollVideo();
}