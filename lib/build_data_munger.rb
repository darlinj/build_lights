require 'nokogiri'

class BuildDataMunger
  def initialize data
    @build_data = Nokogiri.parse(data)
    @build_data.remove_namespaces!
  end

  def amalgamate
    "#{green?} #{building?}".strip
  end

  private 
  def green?
    if build_status_contains?("broken")
      "red"
    else
      "green"
    end
  end

  def build_status_contains?(text)
    !build_status_list.select { |status| status.downcase =~ /#{text}/ }.empty?
  end

  def building?
    "building" if build_status_contains?("building")
  end

  def build_status_list
    @status_list ||= @build_data.xpath("//title").map{|c| c.content.strip}
  end

end
