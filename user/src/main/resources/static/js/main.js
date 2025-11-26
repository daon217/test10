/**
 * 반려동물 케어 시스템 - 메인 JavaScript (최적화)
 */

document.addEventListener('DOMContentLoaded', function() {
    // 초기화 함수들
    initScrollHeader();
    initSmoothScroll();
    initServiceCards();
    initEmergencyBanner();
    initMobileMenu();
    initAOS();

    // ✅ 이미지 시퀀스 초기화 (scroll-sequence.js에서)
    if (typeof initScrollSequence === 'function') {
        initScrollSequence();
    }
});

/**
 * 스크롤시 헤더 스타일 변경
 */
function initScrollHeader() {
    const header = document.querySelector('.pet-header');
    if (!header) return;

    let lastScroll = 0;

    window.addEventListener('scroll', function() {
        const currentScroll = window.pageYOffset;

        if (currentScroll > 50) {
            header.classList.add('scrolled');
        } else {
            header.classList.remove('scrolled');
        }

        lastScroll = currentScroll;
    }, { passive: true }); // ✅ passive로 성능 향상
}

/**
 * 부드러운 스크롤 효과
 */
function initSmoothScroll() {
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function(e) {
            const href = this.getAttribute('href');
            if (href === '#') return;

            e.preventDefault();
            const target = document.querySelector(href);

            if (target) {
                const offsetTop = target.offsetTop - 80;
                window.scrollTo({
                    top: offsetTop,
                    behavior: 'smooth'
                });
            }
        });
    });
}

/**
 * 서비스 카드 호버 효과
 */
function initServiceCards() {
    const cards = document.querySelectorAll('.service-card');

    cards.forEach(card => {
        card.addEventListener('mouseenter', function() {
            this.style.transform = 'translateY(-10px) scale(1.02)';
        });

        card.addEventListener('mouseleave', function() {
            this.style.transform = 'translateY(0) scale(1)';
        });
    });
}

/**
 * 응급 상황 배너 관리
 */
function initEmergencyBanner() {
    const STORAGE_KEY = 'petEmergencyBannerClosed';
    const banner = document.getElementById('emergencyBanner');
    const closeBtn = document.getElementById('closeEmergencyBanner');

    if (!banner) return;

    // 이전에 닫았는지 확인
    const closedDate = localStorage.getItem(STORAGE_KEY);
    if (closedDate) {
        const now = new Date();
        const closed = new Date(closedDate);
        const hoursDiff = (now - closed) / (1000 * 60 * 60);

        if (hoursDiff < 24) {
            banner.style.display = 'none';
            return;
        }
    }

    // 배너 표시
    setTimeout(() => {
        banner.classList.add('show');
    }, 2000);

    // 닫기 버튼
    if (closeBtn) {
        closeBtn.addEventListener('click', function() {
            banner.classList.remove('show');
            localStorage.setItem(STORAGE_KEY, new Date().toISOString());

            setTimeout(() => {
                banner.style.display = 'none';
            }, 500);
        });
    }
}

/**
 * 모바일 메뉴 토글
 */
function initMobileMenu() {
    const toggler = document.querySelector('.navbar-toggler');
    const navCollapse = document.querySelector('.navbar-collapse');

    if (!toggler || !navCollapse) return;

    const navLinks = navCollapse.querySelectorAll('.nav-link');
    navLinks.forEach(link => {
        link.addEventListener('click', function() {
            if (window.innerWidth <= 768 && $(navCollapse).hasClass('show')) {
                $(navCollapse).collapse('hide');
            }
        });
    });
}

/**
 * 스크롤 애니메이션 초기화 (AOS 대체)
 */
function initAOS() {
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -100px 0px'
    };

    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('aos-animate');
                observer.unobserve(entry.target);
            }
        });
    }, observerOptions);

    document.querySelectorAll('[data-aos]').forEach(el => {
        observer.observe(el);
    });
}

/**
 * 펫 정보 카드 애니메이션
 */
function animatePetStats() {
    const stats = document.querySelectorAll('.stat-number');

    stats.forEach(stat => {
        const target = parseInt(stat.getAttribute('data-target'));
        const duration = 2000;
        const increment = target / (duration / 16);
        let current = 0;

        const updateNumber = () => {
            current += increment;
            if (current < target) {
                stat.textContent = Math.floor(current).toLocaleString();
                requestAnimationFrame(updateNumber);
            } else {
                stat.textContent = target.toLocaleString();
            }
        };

        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    updateNumber();
                    observer.unobserve(entry.target);
                }
            });
        });

        observer.observe(stat);
    });
}

/**
 * 예약 모달 관리
 */
function initReservationModal() {
    const modal = document.getElementById('reservationModal');
    if (!modal) return;

    $(modal).on('show.bs.modal', function(e) {
        const button = e.relatedTarget;
        if (button) {
            const service = button.getAttribute('data-service');
            if (service) {
                const serviceInput = modal.querySelector('#reservationService');
                if (serviceInput) {
                    serviceInput.value = service;
                }
            }
        }
    });
}

/**
 * 실시간 시계
 */
function updateClock() {
    const clockElement = document.getElementById('currentTime');
    if (!clockElement) return;

    const now = new Date();
    const hours = now.getHours().toString().padStart(2, '0');
    const minutes = now.getMinutes().toString().padStart(2, '0');
    const seconds = now.getSeconds().toString().padStart(2, '0');

    clockElement.textContent = `${hours}:${minutes}:${seconds}`;
}

setInterval(updateClock, 1000);

// 페이지 로드 완료 시
window.addEventListener('load', function() {
    console.log('🐾 PetCare Plus loaded successfully');

    animatePetStats();
    initReservationModal();
});

// 유틸리티 함수들
const PetUtils = {
    formatPhone: function(phone) {
        return phone.replace(/(\d{3})(\d{4})(\d{4})/, '$1-$2-$3');
    },

    formatDate: function(date) {
        const options = { year: 'numeric', month: 'long', day: 'numeric' };
        return new Date(date).toLocaleDateString('ko-KR', options);
    },

    showToast: function(message, type = 'info') {
        const toastContainer = document.getElementById('toastContainer') || createToastContainer();

        const toast = document.createElement('div');
        toast.className = `toast toast-${type} show`;
        toast.innerHTML = `
            <div class="toast-body">
                <i class="fas ${getToastIcon(type)}"></i>
                <span>${message}</span>
            </div>
        `;

        toastContainer.appendChild(toast);

        setTimeout(() => {
            toast.classList.remove('show');
            setTimeout(() => toast.remove(), 300);
        }, 3000);
    }
};

function createToastContainer() {
    const container = document.createElement('div');
    container.id = 'toastContainer';
    container.style.cssText = 'position: fixed; top: 100px; right: 20px; z-index: 9999;';
    document.body.appendChild(container);
    return container;
}

function getToastIcon(type) {
    const icons = {
        'success': 'fa-check-circle',
        'error': 'fa-exclamation-circle',
        'warning': 'fa-exclamation-triangle',
        'info': 'fa-info-circle'
    };
    return icons[type] || icons['info'];
}

window.PetUtils = PetUtils;