// Smooth scrolling for anchor links
document.querySelectorAll('a[href^="#"]').forEach((anchor) => {
  anchor.addEventListener("click", function (e) {
    e.preventDefault();
    const target = document.querySelector(this.getAttribute("href"));
    if (target) {
      target.scrollIntoView({
        behavior: "smooth",
        block: "start",
      });
    }
  });
});

// Search functionality
const searchInput = document.querySelector(".search-input");
if (searchInput) {
  searchInput.addEventListener("input", (e) => {
    const searchTerm = e.target.value.toLowerCase();
    const templateCards = document.querySelectorAll(".template-card");

    templateCards.forEach((card) => {
      const title = card.querySelector(".template-title").textContent.toLowerCase();
      const description = card.querySelector(".template-description").textContent.toLowerCase();
      const category = card.querySelector(".template-category").textContent.toLowerCase();

      if (title.includes(searchTerm) || description.includes(searchTerm) || category.includes(searchTerm)) {
        card.style.display = "block";
      } else {
        card.style.display = searchTerm === "" ? "block" : "none";
      }
    });
  });
}

// Template card click handlers
document.querySelectorAll(".template-card").forEach((card) => {
  card.addEventListener("click", function () {
    const templateTitle = this.querySelector(".template-title").textContent.trim();
    const encodedTitle = encodeURIComponent(templateTitle);
    window.location.href = `TemplateDetail.jsp?title=${encodedTitle}`;
  });
});

// Header scroll effect
window.addEventListener("scroll", () => {
  const header = document.querySelector(".header");
  if (window.scrollY > 100) {
    header.style.background = "rgba(255, 255, 255, 0.95)";
  } else {
    header.style.background = "rgba(255, 255, 255, 0.8)";
  }
});

// Animation on scroll (simple version)
const observerOptions = {
  threshold: 0.1,
  rootMargin: "0px 0px -50px 0px",
};

const observer = new IntersectionObserver((entries) => {
  entries.forEach((entry) => {
    if (entry.isIntersecting) {
      entry.target.style.opacity = "1";
      entry.target.style.transform = "translateY(0)";
    }
  });
}, observerOptions);

// Observe elements for animation
document.querySelectorAll(".feature-card, .template-card").forEach((el) => {
  el.style.opacity = "0";
  el.style.transform = "translateY(20px)";
  el.style.transition = "opacity 0.6s ease, transform 0.6s ease";
  observer.observe(el);
});

// Mobile menu toggle (if needed)
function toggleMobileMenu() {
  const authButtons = document.querySelector(".auth-buttons");
  authButtons.classList.toggle("mobile-open");
}

// Add mobile styles if needed
const style = document.createElement("style");
style.textContent = `
    @media (max-width: 768px) {
        .auth-buttons.mobile-open {
            position: absolute;
            top: 100%;
            right: 20px;
            background: white;
            border: 1px solid #e5e7eb;
            border-radius: 8px;
            padding: 16px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
            flex-direction: column;
            width: 200px;
        }
    }
`;
document.head.appendChild(style);
