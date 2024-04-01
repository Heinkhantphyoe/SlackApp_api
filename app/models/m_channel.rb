class MChannel < ApplicationRecord
    belongs_to :m_workspace
    has_many :passive_relationships, class_name:  "TUserChannels",
                                      foreign_key: "channelid",
                                      dependent:   :destroy
                                     
      has_many :m_channels, through: :passive_relationships, source: :m_channel
      validates :channel_name,  presence: true, length: { maximum: 50 }
  end
  