require "test_helper"

class LangMiniTest < ActiveSupport::TestCase
  def setup
    LangMini.reset
  end

  def test_get_default_logger
    assert_equal("Logger", LangMini.logger.class.name)
  end

  def test_set_logger
    LangMini.logger = "LOGGER"
    assert_equal("LOGGER", LangMini.logger)
  end

  def test_logger_debug
    logger_mock = mock
    logger_mock.expects(:debug).with("TEST")
    LangMini.logger = logger_mock
    LangMini.logger.debug("TEST")
  end
end
