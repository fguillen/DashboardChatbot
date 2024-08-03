// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
console.log(">>>> Loading application.js");

import "@hotwired/turbo-rails"
import "controllers"
import "turbo_events_debug"

// Chartkick
import "chartkick"
import "Chart.bundle"

// Turbo only activate when explicitly activated
// Turbo.setFormMode("optin") // => Not working :/
