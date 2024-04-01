class TGroupThread < ApplicationRecord
  belongs_to :t_group_message
  belongs_to :m_user
end
