class ShiftSeparation < ApplicationRecord
  belongs_to :master
  default_scope -> { order(start_time: :asc) }
  validates :name, presence: true
  validates :start_time, presence: true
  validates :finish_time, presence: true
  validate  :start_end_check
  
  #start_timeとfinish_timeの大小関係を制限(start < finish => true)
  #正し、夜勤の時間帯設定(21時~)にはこの制限を解除する
  def start_end_check
    if self.start_time.present? && self.finish_time.present?
      errors.add(:finish_time, "が開始時刻を上回っています。正しく記入してください。") if self.start_time > self.finish_time && self.start_time.hour < 21
    end
  end

  #空きシフトの自動入力に使う
  def start_hour
    if self.start_time.hour < 10
      "0#{self.start_time.hour}"
    else
      self.start_time.hour
    end
  end

  #空きシフトの自動入力に使う
  def finish_hour
    if self.finish_time.hour < 10
      "0#{self.finish_time.hour}"
    else
      self.finish_time.hour
    end
  end

  #新人従業員ようにナビを表示するためにシフト時間割の時刻を返す
  def start_to_finish
    "#{self.start_time.strftime("%H:%M")}-#{self.finish_time.strftime("%H:%M")}"
  end
end
