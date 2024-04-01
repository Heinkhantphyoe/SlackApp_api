class MWorkspace < ApplicationRecord
  has_many :m_channels, dependent: :destroy
  
  has_many :passive_relationships, class_name:  "TUserWorkspace",
  foreign_key: "workspaceid",
  dependent:   :destroy
 
  has_many :m_workspaces, through: :passive_relationships, source: :m_workspace
end
