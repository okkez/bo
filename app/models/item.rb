# -*- coding: utf-8 -*-
# == Schema Information
# Schema version: 20091204080113
#
# Table name: items
#
#  id           :integer       not null, primary key
#  event_id     :integer       index_items_on_event_id
#  founds_in    :integer
#  founds_out   :integer
#  created_at   :datetime
#  updated_at   :datetime
#  lock_version :integer       default(0), not null
#

class Item < ActiveRecord::Base
  validates_numericality_of :founds_in, :greater_than => 0, :only_integer => true, :allow_nil => true
  validates_numericality_of :founds_out, :greater_than => 0, :only_integer => true, :allow_nil => true

  validate :validates_tags

  belongs_to :event

  acts_as_taggable_on :tags

  private

  def validates_tags
    keywords = self.tag_list.map{|tag| Keyword.find_by_name(tag) }.compact
    return if keywords.empty?
    roots = keywords.map{|k| k.root.id }
    unless roots.uniq.size == 1
      errors.add_to_base("矛盾するタグは登録できません")
    end
  end

end
