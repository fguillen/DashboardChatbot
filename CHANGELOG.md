# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.0.13] - 2024-08-04 (bda27aaffa035c23f7f9fa996e619749e7cb8093)

### Added

- Hotwire integration. Realtime show of new messages in Conversations
- Conversations messages list auto scroll when new message added.
- Assistant.on_new_message callback
- User messages are sticky on the top when scrolling

### Removed

- Code syntax highlightin. Too complex and not adding too much
- Any trace of langchainrb


## [0.0.11] - 2024-08-03

### Changed

- Integrated profesional [theme Phoenix](https://themes.getbootstrap.com/product/phoenix-admin-dashboard-webapp-template/)
- Refactor structure to implement a more low level API interface
- Integrated OpenRouter API

### Added

- Posibility to choose the model
- Automatic scroll when new messages appear
- Styling Conversations list page

## [0.0.5] - 2024-07-11

### Added

- Integrating "tool" to draw charts (line, column).
- Message form capture ctrl + Enter to send message.
- Schema description added into the system instructions.


## [0.0.3] - 2024-07-07

### Added

- Copy paste buttons work
- Syntax highlighting in function call arguments
- Syntax highlight
- Message show page
- Improvement in Message bubble
- Capturing errors in LLM request and show it in the Conversation
- More system instructions to improve SQL generation
- Added inner link to each message bubgle
