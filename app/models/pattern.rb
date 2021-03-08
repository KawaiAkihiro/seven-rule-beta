class Pattern < ApplicationRecord
  belongs_to :staff
  
  default_scope -> { order(start: :asc) }

  #自動選択機能のために使う
  def start_h
    if self.start.hour < 10
      "0#{self.start.hour}"
    else
      self.start.hour
    end
  end
  #自動選択機能のために使う
  def finish_h
    if self.finish.hour < 10
      "0#{self.finish.hour}"
    else
      self.finish.hour
    end
  end

  #パターンの時刻を返す
  def start_to_finish
    "#{self.start.strftime("%H:%M")}-#{self.finish.strftime("%H:%M")}"
  end
end
