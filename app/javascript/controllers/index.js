// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import { application } from "controllers/application"

import CondeSyntaxHighlighterController from "controllers/conde_syntax_highlighter_controller"
application.register("conde-syntax-highlighter", CondeSyntaxHighlighterController)

import CopyToClipboardController from "controllers/copy_to_clipboard_controller"
application.register("copy-to-clipboard", CopyToClipboardController)

import HelloController from "controllers/hello_controller"
application.register("hello", HelloController)

import MessageFormController from "controllers/message_form_controller"
application.register("message-form", MessageFormController)

import SubmitOnCmdEnterController from "controllers/submit_on_cmd_enter_controller"
application.register("submit-on-cmd-enter", SubmitOnCmdEnterController)
