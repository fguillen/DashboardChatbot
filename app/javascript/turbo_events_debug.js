console.log(">>>> Loading turbo-events-debug.js");

const eventNames = [
  "turbo:click",
  "turbo:before-visit",
  "turbo:visit",
  "turbo:submit-start",
  "turbo:before-fetch-request",
  "turbo:before-fetch-response",
  "turbo:submit-end",
  "turbo:before-cache",
  "turbo:before-render",
  "turbo:before-stream-render",
  "turbo:render",
  "turbo:load",
  "turbo:frame-render",
  "turbo:frame-load",
  "turbo:fetch-request-error",
]

eventNames.forEach(eventName => {
  document.addEventListener(eventName, (event) => {
    console.log(event.type, event);
  });
});
