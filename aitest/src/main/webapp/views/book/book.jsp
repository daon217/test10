<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<script>
  const bookRecommender = {
    init() {
      $('#book-spinner').hide();
      $('#recommend-form').on('submit', (event) => {
        event.preventDefault();
        this.recommend();
      });
    },
    recommend() {
      $('#book-spinner').show();
      $('#recommend-result').empty();

      const payload = {
        readingFrequency: $('input[name="reading-frequency"]:checked').val(),
        todayMood: $('input[name="today-mood"]:checked').val(),
        moodReason: $('#mood-reason').val(),
        dailyTime: $('#daily-time').val()
      };

      $.ajax({
        url: '<c:url value="/book/recommend"/>',
        type: 'POST',
        data: payload,
        success: (response) => {
          $('#book-spinner').hide();
          this.display(response);
        },
        error: () => {
          $('#book-spinner').hide();
          this.display('추천 결과를 불러오는 중 오류가 발생했습니다. 잠시 후 다시 시도해 주세요.');
        }
      });
    },
    display(text) {
      const template = `
        <div class="card mt-3">
          <div class="card-body">
            <pre class="mb-0">${text}</pre>
          </div>
        </div>
      `;
      $('#recommend-result').append(template);
    }
  };

  $(() => {
    bookRecommender.init();
  });
</script>

<div class="col-sm-10">
  <h2>recommend Book</h2>
  <p class="text-muted">간단한 질문에 답하면 AI가 오늘 읽기 좋은 책을 추천해 드립니다.</p>

  <form id="recommend-form">
    <div class="form-group">
      <label class="d-block">1️⃣ 평소에 책을 얼마나 읽나요?</label>
      <div class="form-check form-check-inline">
        <input class="form-check-input" type="radio" name="reading-frequency" id="reading-frequency-daily" value="거의 매일" required>
        <label class="form-check-label" for="reading-frequency-daily">거의 매일</label>
      </div>
      <div class="form-check form-check-inline">
        <input class="form-check-input" type="radio" name="reading-frequency" id="reading-frequency-sometimes" value="가끔">
        <label class="form-check-label" for="reading-frequency-sometimes">가끔</label>
      </div>
      <div class="form-check form-check-inline">
        <input class="form-check-input" type="radio" name="reading-frequency" id="reading-frequency-rarely" value="거의 안 읽음">
        <label class="form-check-label" for="reading-frequency-rarely">거의 안 읽음</label>
      </div>
    </div>
    <div class="form-group mt-3">
      <label class="d-block">2️⃣ 오늘 기분이 어떤가요?</label>
      <div class="form-check form-check-inline">
        <input class="form-check-input" type="radio" name="today-mood" id="today-mood-good" value="좋음" required>
        <label class="form-check-label" for="today-mood-good">좋음</label>
      </div>
      <div class="form-check form-check-inline">
        <input class="form-check-input" type="radio" name="today-mood" id="today-mood-normal" value="보통">
        <label class="form-check-label" for="today-mood-normal">보통</label>
      </div>
      <div class="form-check form-check-inline">
        <input class="form-check-input" type="radio" name="today-mood" id="today-mood-bad" value="안 좋음">
        <label class="form-check-label" for="today-mood-bad">안 좋음</label>
      </div>
    </div>
    <div class="form-group mt-3">
      <label for="mood-reason">2-1️⃣ 그렇게 느끼는 이유는 무엇인가요?</label>
      <textarea id="mood-reason" name="moodReason" class="form-control" rows="2" placeholder="예: 회사에서 좋은 소식을 들었어요, 요즘 일이 많아서 지쳐요 등" required></textarea>
    </div>
    <div class="form-group mt-3">
      <label for="daily-time">3️⃣ 오늘 독서에 사용할 수 있는 시간은 얼마나 되나요?</label>
      <textarea id="daily-time" name="dailyTime" class="form-control" rows="2" placeholder="예: 출퇴근길에 30분 정도, 자기 전 1시간 등" required></textarea>
    </div>

    <div class="d-flex align-items-center mt-3">
      <button type="submit" class="btn btn-primary">AI에게 추천 받기</button>
      <div class="spinner-border text-primary ml-3" role="status" id="book-spinner">
        <span class="sr-only">Loading...</span>
      </div>
    </div>
  </form>

  <div id="recommend-result" class="mt-4"></div>
</div>