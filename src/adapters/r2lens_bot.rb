# frozen_string_literal: true

require "telegram/bot"

module Adapters
  class R2lensBot
    def initialize(token:, chat_id:)
      @bot = ::Telegram::Bot::Client.new(token)
      @chat_id = chat_id
    end

    def post(text)
      @bot.api.send_message(chat_id: @chat_id, text: text, parse_mode: "HTML")
    end
  end
end
