class TargetSerializer < ActiveModel::Serializer
  attributes :area_length, :id, :lat, :lng, :title, :topic_id
end