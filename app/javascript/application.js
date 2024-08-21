// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

// on document loaded
document.addEventListener("turbo:load", () => {
  nav_active();
})

function nav_active() {
  const current_location = location.pathname;
  const links = document.querySelectorAll('.nav-link');
  for (const link of links) {
    if (current_location.startsWith(link.pathname)) {
      link.classList.add('active');
    }
  }
}