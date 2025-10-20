module Services
  class PlayerGrowthMeasureService
    def self.call(player_then, player_now)
      return nil if player_then.name != player_now.name
      
      level = player_now.level - player_then.level
      percent_now = level * 100 + player_now.percent
      percent = percent_now - player_then.percent
      { level:, percent: }
    end
  end
end
