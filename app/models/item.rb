# -*- coding: utf-8 -*-
# == Schema Information
# Schema version: 20100209145338
#
# Table name: items
#
#  id           :integer       not null, primary key
#  event_id     :integer       index_items_on_event_id
#  founds_in    :integer       default(0), not null
#  founds_out   :integer       default(0), not null
#  created_at   :datetime
#  updated_at   :datetime
#  lock_version :integer       default(0), not null
#

class Item < ActiveRecord::Base
  with_options :only_integer => true, :allow_nil => true do |item|
    item.validates_numericality_of :founds_in, :greater_than_or_equal_to => 0
    item.validates_numericality_of :founds_out, :greater_than_or_equal_to => 0
  end

  validate :validates_tags

  belongs_to :event

  acts_as_taggable_on :tags

  before_save :update_tags

  private

  def keywords
    self.tag_list.map{|tag| Keyword.find_by_name(tag) }.compact
  end

  def validates_tags
    return if keywords.empty?
    roots = keywords.map{|k| k.root.id }
    unless roots.uniq.size == 1
      errors.add_to_base("矛盾するタグは登録できません: #{self.tag_list.join(' ')}")
    end
  end

  def update_tags
    self.tag_list = (self.tag_list + keywords.map(&:ancestors).flatten.map(&:name)).uniq.join(" ")
  end

end
