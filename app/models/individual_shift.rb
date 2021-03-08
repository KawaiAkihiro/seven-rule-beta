class IndividualShift < ApplicationRecord
  belongs_to :staff

  has_one :master, through: :staff

  default_scope -> { order(start: :asc) }
  validate  :start_end_check
  
  #startとfinishの大小関係を制限(start < finish => true)
  #正し、夜勤の時間帯設定(21時~)にはこの制限を解除する
  def start_end_check
    if self.start.present? && self.finish.present?
      errors.add(:finish, "が開始時刻を上回っています。正しく記入してください。") if self.start.hour >= self.finish.hour && self.start.hour <= 21
    end
  end

  #カレンダーで表示する名前
  def parent
    if self.staff.staff_number == 0
      if self.plan == nil
        " "
      else
        self.plan
      end
    else
      self.staff.staff_name
    end
    
  end

  #終日判定
  def allDay
    unless self.finish.present?
      true
    else
      false
    end
  end

  #トレーニング中の従業員の枠線は赤にする
  def color
    if self.staff.training_mode == true
      "red"
    else
      "black"
    end
  end

  def fulltime
    str = [ "#{self.start.strftime("%m/%d %H")}" + "時", "#{self.finish.strftime("%H")}" + "時" ]
    return str.join(" ~ ")
  end

  #個人シフト提出中に表示する時刻
  def time
    str = [ "#{self.start.strftime("%H")}", "#{self.finish.strftime("%H")}" ]
    return str.join(" ~ ")
    
  end

  #空きシフトは背景を黄色で表示
  def backgroundColor
    if self.staff.staff_number == 0 && self.finish != nil
      "yellow"
    else
      "white"
    end
  end
end
