# -*- coding: utf-8 -*-
require 'spec_helper'

describe "/events/new" do
  describe "with template" do
    before do
      event = Factory.build(:event,
                            :user => Factory(:user),
                            :items => [Factory.build(:item, :tag_list => "食費"),
                                       Factory.build(:item, :founds_in => 333, :tag_list => "食費")])
      event.template = true
      assigns[:event] = event
      render 'events/new'
    end
    it{ response.should have_tag('table.event') }
    it do
      response.should have_tag('table.items') do
        with_tag("tbody tr td.founds-in input[value=?]", '333')
      end
    end
    it do
      response.should have_tag('table.items') do
        with_tag("tbody tr td.tag input[value=?]", '食費')
      end
    end
    it{ response.should have_tag("table.event tbody tr th", "テンプレート") }
  end
end
