/* ============================================
   非洲旅遊網站 - 互動功能
   平滑捲動、Modal、浮動 CTA
   ============================================ */

// ============ Modal 功能 ============
function openModal() {
  const modal = document.getElementById('ctaModal');
  if (modal) {
    modal.classList.add('is-open');   // ✅ 改成加 class
  }
}

function closeModal() {
  const modal = document.getElementById('ctaModal');
  if (modal) {
    modal.classList.remove('is-open'); // ✅ 改成移除 class
  }
}

// 點擊背景關閉 Modal
window.addEventListener('click', function(event) {
  const modal = document.getElementById('ctaModal');
  if (event.target === modal) {
    closeModal();
  }
});

// ============ 平滑捲動（目錄連結） ============
document.addEventListener('DOMContentLoaded', function() {
  // 為所有內部連結添加平滑捲動
  const links = document.querySelectorAll('a[href^="#"]');

  links.forEach(link => {
    link.addEventListener('click', function(e) {
      const targetId = this.getAttribute('href');

      // 如果只是 "#"（例如 CTA placeholder），不要做平滑捲動
      if (targetId === '#') return;

      e.preventDefault();
      const target = document.querySelector(targetId);

      if (target) {
        const headerHeight = document.querySelector('header')?.offsetHeight || 0;
        const targetPosition = target.offsetTop - headerHeight - 30;

        window.scrollTo({
          top: targetPosition,
          behavior: 'smooth'
        });
      }
    });
  });
});

// ============ 浮動 CTA 按鈕顯示 ============
window.addEventListener('scroll', function() {
  const floatingCta = document.querySelector('.floating-cta');
  const heroSection = document.querySelector('.hero');

  if (!floatingCta || !heroSection) return;

  const heroBottom = heroSection.offsetTop + heroSection.offsetHeight;

  if (window.scrollY > heroBottom - 100) {
    floatingCta.classList.add('show');
  } else {
    floatingCta.classList.remove('show');
  }
});

// ============ 頁面載入動畫 ============
document.addEventListener('DOMContentLoaded', function() {
  document.body.style.opacity = '0';
  document.body.style.transition = 'opacity 0.8s ease';

  setTimeout(function() {
    document.body.style.opacity = '1';
  }, 100);
});

// ============ CTA 按鈕事件 - 只綁定 cta-link 和 floating-cta ============
document.addEventListener('DOMContentLoaded', function() {
  // 只為 cta-link 和 floating-cta 綁定 Modal 事件
  // cta-button 不再被攔截，保持正常導覽行為
  const modalTriggers = document.querySelectorAll('.cta-link, .floating-cta');

  modalTriggers.forEach(el => {
    el.addEventListener('click', function(e) {
      e.preventDefault();
      openModal();
    });
  });
});

// ============ 頁面轉換效果 ============
document.addEventListener('DOMContentLoaded', function() {
  // 為所有外部連結添加淡出效果（同站導頁）
  const links = document.querySelectorAll('a[href$=".html"]');

  links.forEach(link => {
    link.addEventListener('click', function(e) {
      // 允許正常導航
      // 你若之後想做淡出轉場，可以在這裡加 e.preventDefault() + 動畫 + location.href
    });
  });
});

// ============ 無障礙支援 ============
// 按 Escape 鍵關閉 Modal
document.addEventListener('keydown', function(event) {
  if (event.key === 'Escape') {
    closeModal();
  }
});
