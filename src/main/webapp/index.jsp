<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js" integrity="sha384-I7E8VVD/ismYTF4hNIPjVp/Zjvgyol6VFvRkX/vR+Vc4jQkC+hVqc2pM8ODewa9r" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.min.js" integrity="sha384-0pUGZvbkm6XF6gxjEnlmuGrJXVbNuzT9qBBavbLwCsOGabYfZo0T0to5eqruptLy" crossorigin="anonymous"></script>
</head>
<body>
  <div>
      <h2>던전 진행 상황</h2>
      <ul>
          <li><input type="checkbox" id="dungeon1"> 던전 1</li>
          <li><input type="checkbox" id="dungeon2"> 던전 2</li>
          <li><input type="checkbox" id="dungeon3"> 던전 3</li>
      </ul>

      <h2>캐릭터 진행 상황</h2>
      <ul>
          <li><input type="checkbox" id="character1" disabled> 캐릭터 1</li>
          <li><input type="checkbox" id="character2" disabled> 캐릭터 2</li>
      </ul>

      <h3>전체 진행 상황: <span id="progress">0%</span></h3>
      <progress id="progressBar" value="0" max="100"></progress>
  </div>

<pre>

### 1. **기능 요구 사항 분석**

#### a. **7일마다 초기화**
   - 매주 수요일마다 앱 내에서 진행 상태를 초기화해야 합니다. 이는 서버 측에서 매주 자동으로 처리되도록 할 수 있습니다.
   
#### b. **현재 진행상황 / 전체 진행상황 표기**
   - 각 던전의 진행 상황을 체크하고, 이를 바탕으로 전체 진행 상태를 계산하여 화면에 표시합니다.
   
#### c. **체크 여부에 따른 진행 상황 결정**
   - 사용자가 던전이나 캐릭터를 체크할 때마다 해당 항목이 완료된 것으로 간주하고, 이를 진행 상황에 반영합니다.

#### d. **캐릭터와 던전 연동**
   - 던전 3개를 완료하면, 특정 캐릭터도 완료로 간주되도록 설정합니다.

### 2. **구현해야 할 주요 컴포넌트**

- **사용자 인터페이스 (UI)**
  - 던전 목록
  - 캐릭터 목록
  - 각 던전과 캐릭터에 대한 체크박스
  - 진행 상황을 시각적으로 표현할 프로그레스 바 또는 퍼센트 표시

- **서버 / 백엔드**
  - 매주 수요일에 데이터를 초기화하는 기능
  - 던전과 캐릭터의 완료 여부를 추적하고, 이를 기준으로 상태를 업데이트하는 로직
  - 사용자가 체크한 상태를 서버에 저장하여 새로고침 시 유지되는 기능

- **데이터 저장**
  - 로컬 스토리지 또는 데이터베이스를 이용해 사용자별 상태를 저장 (웹 앱에서 로컬 스토리지를 사용하는 방법도 있지만, 실제 배포에서는 데이터베이스가 필요할 수 있습니다)

### 3. **UI 디자인**

#### **1. 던전과 캐릭터 목록**
- 각 던전이 체크박스로 나타나고, 던전이 완료되면 그에 해당하는 캐릭터도 자동으로 완료 체크되도록 합니다.
 -html 참고




#### **2. 현재 진행상황 계산**
- 던전 완료 여부에 따라 캐릭터의 상태를 자동으로 업데이트합니다. 던전 3개를 완료하면 캐릭터도 체크됩니다.
- 진행 상황을 퍼센트로 나타낼 수 있습니다. 던전 3개 중 2개가 완료되면 66%로 표시됩니다.

### 4. **로직 구현**

#### **JavaScript로 진행 상황 계산 및 업데이트**
```javascript
// 던전과 캐릭터의 상태를 저장
let dungeonStatus = [false, false, false];  // 던전 3개
let characterStatus = [false, false];       // 캐릭터 2개

// 던전 체크박스 클릭 이벤트 처리
const dungeonCheckboxes = document.querySelectorAll('input[type="checkbox"]:not(#dungeon3)');
const characterCheckboxes = document.querySelectorAll('input[type="checkbox"]:not(#character1)');

// 던전 체크 시 캐릭터 체크 여부 업데이트
dungeonCheckboxes.forEach((checkbox, index) => {
  checkbox.addEventListener('change', () => {
    dungeonStatus[index] = checkbox.checked;
    updateCharacterStatus();
    updateProgress();
  });
});

// 캐릭터 상태 업데이트 (던전 3개 완료 시)
function updateCharacterStatus() {
  if (dungeonStatus[0] && dungeonStatus[1] && dungeonStatus[2]) {
    characterStatus[0] = true;  // 캐릭터 1 완료
    document.getElementById('character1').checked = true;  // 캐릭터 1 체크
  }

  if (dungeonStatus[1] && dungeonStatus[2]) {
    characterStatus[1] = true;  // 캐릭터 2 완료
    document.getElementById('character2').checked = true;  // 캐릭터 2 체크
  }
}

// 진행 상황 업데이트
function updateProgress() {
  let completedDungeons = dungeonStatus.filter(status => status).length;
  let totalDungeons = dungeonStatus.length;

  let progress = (completedDungeons / totalDungeons) * 100;
  document.getElementById('progress').textContent = `${progress.toFixed(0)}%`;
  document.getElementById('progressBar').value = progress;
}

// 초기화 버튼 (7일마다)
function resetProgress() {
  dungeonStatus = [false, false, false];
  characterStatus = [false, false];
  
  dungeonCheckboxes.forEach(cb => cb.checked = false);
  characterCheckboxes.forEach(cb => cb.checked = false);
  
  updateProgress();
}

// 주기적인 초기화 (수요일마다)
setInterval(() => {
  let today = new Date();
  if (today.getDay() === 3) {  // 수요일(3)
    resetProgress();
  }
}, 86400000);  // 24시간마다 체크
```

#### **기능 설명**
- **던전 체크 시 캐릭터 상태 업데이트**: 던전이 모두 완료되면 해당 캐릭터가 자동으로 완료 처리됩니다.
- **진행 상황 퍼센트**: 던전의 완료된 비율을 계산하여 진행 상태를 퍼센트로 표시합니다.
- **주기적인 초기화**: 매일 수요일마다 자동으로 진행 상태가 초기화되도록 설정할 수 있습니다.

### 5. **백엔드(선택 사항)**

만약 진행 상태를 서버에 저장하고 여러 사용자가 관리할 수 있도록 한다면, 데이터베이스와 서버가 필요합니다. 예를 들어, **Node.js**와 **MongoDB**를 사용해서 사용자별 진행 상태를 저장하고, 매주 수요일에 자동으로 초기화하는 방식으로 구현할 수 있습니다.

### 6. **배포 및 최적화**
- 웹 애플리케이션을 배포하려면 **Netlify**, **Vercel** 또는 **Heroku** 등을 사용할 수 있습니다.
- **로컬 스토리지**를 사용하면 데이터는 클라이언트 측에서만 유지되므로, 실제 배포에서는 서버 측에 데이터를 저장하고 관리하는 것이 좋습니다.

---

이와 같은 방식으로 **게임화된 할 일 관리 시스템**을 구현할 수 있습니다. 던전과 캐릭터의 진행 상태를 체크하고, 이를 자동으로 연동하는 시스템이 게임처럼 흥미롭고 실용적일 것입니다! 😊

물론입니다! `index.jsp`를 기준으로 URL 트리 구조를 아래와 같이 작성할 수 있습니다. 이 구조는 각 페이지와 리소스가 어떻게 연결되어 있는지 보여줍니다.

### **URL 트리 구조**

```
/
├── index.jsp                     → 기본 홈페이지 (사용자 진행 상황을 보여주는 페이지)
├── resources/                    → 정적 리소스 (CSS, JS, 이미지)
│   ├── css/
│   │   └── style.css             → 스타일 시트
│   ├── js/
│   │   └── script.js             → 자바스크립트 파일
│   └── images/
│       └── logo.png              → 이미지 파일
├── progress                     → 진행상황 관련 페이지 (예: 던전과 캐릭터 체크 리스트)
│   ├── /progress/status          → 현재 진행 상황을 표시하는 페이지
│   └── /progress/overview        → 전체 진행 상황과 완료된 던전/캐릭터를 보여주는 페이지
├── api/                          → 백엔드 API 경로
│   ├── /api/dungeons             → 던전 완료 상태를 서버에 업데이트하는 API
│   └── /api/characters           → 캐릭터 상태를 업데이트하는 API
├── reset                         → 주기적으로 진행 상황을 초기화하는 경로 (매주 수요일)
│   └── /reset/week-reset         → 매주 수요일마다 진행 상황 초기화
└── WEB-INF/                      → 서버에서만 접근 가능한 디렉토리
    ├── lib/
    └── web.xml                   → 서블릿 및 필터 설정
```

### **URL 경로 설명**

1. **`/` (홈페이지, `index.jsp`)**
   - 기본적으로 `index.jsp`가 로드됩니다. 이 페이지에서 사용자의 진행 상황과 전체 진행 상황을 확인할 수 있습니다.
   - 예시: `/index.jsp`

2. **`/resources/` (정적 리소스)**
   - `/resources/css/` → `style.css`: 스타일 시트
   - `/resources/js/` → `script.js`: 자바스크립트 파일
   - `/resources/images/` → `logo.png`: 이미지 파일

3. **`/progress` (진행 상황)**
   - **`/progress/status`**: 사용자가 던전이나 캐릭터 진행 상황을 볼 수 있는 페이지. 각 던전과 캐릭터의 체크박스를 포함하고, 체크 여부에 따라 진행 상황이 표시됩니다.
   - **`/progress/overview`**: 전체적인 진행 상황을 보여주는 페이지. 전체 던전 완료율, 캐릭터 완료율 등을 한눈에 볼 수 있는 대시보드.

4. **`/api` (백엔드 API 경로)**
   - **`/api/dungeons`**: 던전의 완료 상태를 서버에 업데이트하는 API. 사용자가 던전을 완료하면 해당 던전의 상태를 서버에 전송하여 저장합니다.
   - **`/api/characters`**: 캐릭터 상태를 서버에 업데이트하는 API. 던전이 완료되면 연동된 캐릭터 상태를 자동으로 업데이트합니다.

5. **`/reset` (진행 상황 초기화)**
   - **`/reset/week-reset`**: 매주 수요일에 진행 상황을 초기화하는 경로. 서버에서 매주 수요일마다 자동으로 모든 진행 상태를 초기화합니다.

6. **`/WEB-INF/` (서버 전용 디렉토리)**
   - `WEB-INF` 폴더는 서버에서만 접근할 수 있는 설정 파일 및 라이브러리들을 포함하는 디렉토리입니다. 클라이언트는 이 디렉토리 내 파일에 직접 접근할 수 없습니다.

### **예시 URL 경로**

- **홈 페이지**: `/index.jsp`
- **현재 진행 상황**: `/progress/status`
- **전체 진행 상황**: `/progress/overview`
- **던전 상태 업데이트 API**: `/api/dungeons`
- **캐릭터 상태 업데이트 API**: `/api/characters`
- **진행 상황 초기화 (매주 수요일)**: `/reset/week-reset`

위 트리 구조는 각 페이지와 URL이 어떻게 연결되는지, 그리고 정적 리소스 및 백엔드 API가 어떻게 구성되는지 명확하게 보여줍니다. 이 구조를 바탕으로 웹 애플리케이션을 설계하면 더 이해하기 쉽고 효율적으로 개발할 수 있을 거예요!
</pre>
</body>
</html>