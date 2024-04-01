class TGroupMessage < ApplicationRecord
  has_many :t_group_thread, dependent: :destroy
  belongs_to :m_channel
  belongs_to :m_user

  has_many :passive_relationships, class_name:  "TGroupMentionMsg",
                                    foreign_key: "groupmsgid",
                                    dependent:   :destroy
                                   
  has_many :t_group_messages, through: :passive_relationships, source: :t_group_message

  has_many :passive_relationships, class_name:  "TGroupStarMsgs",
                                    foreign_key: "groupmsgid",
                                    dependent:   :destroy
  
  has_many :t_group_messages, through: :passive_relationships, source: :t_group_message
end
