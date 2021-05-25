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
    if self.staff.number == 0
      if self.plan == nil
        "募集中"
      else
        self.plan
      end
    else
      if self.staff.training_mode
        self.staff.name + "(研)"
      else
        self.staff.name
      end
      
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

  def date
    self.start.strftime("%m/%d")
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
    if self.staff.number == 0 && self.finish != nil
      if self.mode == nil
        "yellow"
      elsif self.mode == "fill"
        "#ffb6c1"
      end
    else
      if self.mode == "instead"
        "#87cefa"
      elsif self.mode == nil
        "white"
      end
    end
  end

  def temp_color
    same_time = self.master.individual_shifts.where(start:self.start).where(temporary: false)
    unless allDay 
      if same_time.count < 2
        "red"
      else
        "black"
      end
    else
      "black"
    end
  end
end
