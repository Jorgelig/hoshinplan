class Hoshin < ActiveRecord::Base
  
  include ModelBase

  hobo_model # Don't put anything above this

  fields do
    name :string, :default => 'plan', :null => false
    goals_count :integer, :default => 0, :null => false
    areas_count :integer, :default => 0, :null => false
    objectives_count :integer, :default => 0, :null => false
    indicators_count :integer, :default => 0, :null => false
    outdated_indicators_count :integer, :default => 0, :null => false
    outdated_tasks_count :integer, :default => 0, :null => false
    blind_objectives_count :integer, :default => 0, :null => false
    neglected_objectives_count :integer, :default => 0, :null => false
    tasks_count :integer, :default => 0, :null => false
    objectives_count :integer, :default => 0, :null => false
    hoshins_count :integer, :default => 0, :null => false
    header HoboFields::Types::TextileString
    timestamps
  end
  index [:company_id, :parent_id]
  
  attr_accessible :name, :id, :parent, :parent_id, :company, :company_id, :header
  attr_accessible :areas, :children, :children_ids, :creator_id, :creator
  
  belongs_to :creator, :class_name => "User", :creator => true, :inverse_of => :my_hoshins

  belongs_to :company, :inverse_of => :hoshins, :counter_cache => true
  belongs_to :parent, :inverse_of => :children, :class_name => "Hoshin", :counter_cache => true
  has_many :children, :inverse_of => :parent, :class_name => "Hoshin", :foreign_key => "parent_id", :dependent => :destroy
  
  has_many :areas, -> { order :position }, :dependent => :destroy, :inverse_of => :hoshin
  has_many :objectives, :through => :areas, :inverse_of => :hoshin, :accessible => true
  has_many :indicators, :through => :objectives, :inverse_of => :hoshin, :accessible => true
  has_many :tasks, :through => :objectives, :accessible => true
  has_many :goals, -> { order :position }, :dependent => :destroy, :inverse_of => :hoshin
  
  children :areas
  
  validate :validate_company
  
  default_scope lambda {
    if Company.current_id
      where(:company_id => Company.current_id)
    else
      where(:company_id => UserCompany.select(:company_id).where(:user_id => User.current_id)) unless User.current_user == -1
    end
  }
  
  after_create do |obj|
    user = User.current_user
    user.tutorial_step << :hoshin
    user.save!
  end
  
  def taks_by_status(status)
    tasks.where(:status => status)
  end
  
  def backlog_tasks
    tasks.backlog.order(:lane_pos)
  end
  def active_tasks
    tasks.active.order(:lane_pos)
  end
  def completed_tasks
    tasks.completed.visible.order(:lane_pos)
  end
  def discarded_tasks
    tasks.discarded.visible.order(:lane_pos)
  end
  def outdated_tasks
    tasks.overdue
  end
  def outdated_indicators
    tasks.overdue
  end
  def blind_indicators
    tasks.overdue
  end
  def outdated_indicators
    tasks.overdue
  end
  
  def health_update!
    if self.readonly?
      logger.debug "====== Not updating read-only hoshin"
      return
    end
    neglected = Objective.unscoped.where(hoshin_id: id).neglected.count(:id)
    self.neglected_objectives_count = neglected
    
    outdated_ind = Indicator.unscoped.where(hoshin_id: id).overdue.count(:id)
    self.outdated_indicators_count = outdated_ind

    outdated_tsk = Task.unscoped.where(hoshin_id: id).overdue.count(:id)
    self.outdated_tasks_count = outdated_tsk
    
    blind = Objective.unscoped.where(hoshin_id: id).blind.count(:id)
    self.blind_objectives_count = blind  
  
    self.save!
  end
  
  after_update do |hoshin|
    if hoshin.company_id_changed?
      IndicatorHistory.joins(:indicator).where(:indicators => {:hoshin_id => id}).update_all(:company_id => company_id)
      Indicator.update_all({:company_id => company_id},{:hoshin_id => id})
      Task.update_all({:company_id => company_id},{:hoshin_id => id})
      Objective.update_all({:company_id => company_id},{:hoshin_id => id})
      Area.update_all({:company_id => company_id},{:hoshin_id => id})
      Goal.update_all({:company_id => company_id},{:hoshin_id => id})
    end
  end
  
  
  def users_with_pending_actions
    users = {}
    (objectives.neglected | objectives.blind | indicators.overdue | tasks.overdue).each {|o|
      if (users.has_key? o.responsible)
        users[o.responsible] += 1
      else
        users[o.responsible]=1
      end
    }
    users.sort_by {|k,v| v}.reverse
  end
  
  def cache_key
    objids = Objective.select("id").where(:hoshin_id => id).*.id
    kpiids = Indicator.select("id").includes(:area).where("areas.hoshin_id = ?", id).*.id
    tskids = Task.select("id").includes(:area).where("areas.hoshin_id = ?", id).*.id
    objids = objids.map { |id| "o" + id.to_s }
    kpiids = kpiids.map { |id| "k" + id.to_s }
    tskids = tskids.map { |id| "t" + id.to_s }
    (objids + kpiids + tskids).join("-").hash
  end
  
  def objectives_health
    return 100.0 if objectives_count.to_f == 0
    return 0 if neglected_objectives_count.to_f + blind_objectives_count.to_f > objectives_count.to_f
    100.0 * (1.0 - (neglected_objectives_count.to_f + blind_objectives_count.to_f ) / objectives_count.to_f)
  end
  
  def indicators_health
    return 100.0 if indicators_count.to_f == 0
    100.0 * (1.0 - outdated_indicators_count.to_f / indicators_count.to_f)
  end
  
  def tasks_health
    return 100.0 if tasks_count.to_f == 0
    100.0 * (1.0 - outdated_tasks_count.to_f / tasks_count.to_f)
  end
  
  def health
    ret = incomplete_health
    return ret if ret[:value] < 100 && ret[:action] != 'none'
    
    obj = objectives_health
    ind = indicators_health
    tsk = tasks_health

    ret[:value] = (obj+ind+tsk)/3
    ret
  end
  
  def incomplete_health
    value = 20
    ret = {:action => "none"} unless creator_id == User.current_id
    if goals.size == 0
       ret = ret || {:action => "goal"}
    else
      value += 16
    end
    if areas.size == 0
       ret = ret || {:action => "area"}
    else
       value += 16
    end
    if objectives.size == 0
      ret = ret || { :action => "objective"}
    else
      value += 16
    end
    if indicators.size == 0
      ret = ret || { :action => "indicator"}
    else
      value += 16
    end
    if tasks.size == 0
      ret = ret || { :value => 75, :action => "task"}
    else
      value += 16
    end
    if !User.current_user.tutorial_step?(:followup)
      ret = ret || {:action => "followup"}
    end
    ret = ret || {:action => "none"}
    ret[:value] = value
    return ret
  end
  
  def tutorial
    if User.current_user.id == creator_id && !User.current_user.tutorial_step?(:followup) && health[:action] != 'none' 
       "tutorial"
    else 
      ""
    end
  end
  
  # --- Permissions --- #
  
  def parent_same_company
    User.current_user.administrator? || parent_id.nil? || Hoshin.find(parent_id).company_id == company_id
  end
  
  def validate_company
    errors.add(:company, I18n.t("errors.permission_denied", :default => "Permission denied")) unless same_company
    errors.add(:parent, I18n.t("errors.parent_hoshin_same_company", :default => "Parent hoshin must be from the same company")) unless parent_same_company
  end

  def create_permitted?
    true
  end

  def update_permitted?
    acting_user.administrator? || same_company
  end

  def destroy_permitted?
    acting_user.administrator? || same_creator || same_company_admin
  end

  def view_permitted?(field)
    acting_user.administrator? || self.new_record? || same_company
  end

end
