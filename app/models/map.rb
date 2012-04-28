require 'rubygems'
require 'image_science'

class Map < ActiveRecord::Base
  acts_as_tree
  belongs_to :company
  has_many :map_spots, :dependent => :destroy

  URI = "/images/maps/"

  def self.geturi
    return Map::URI
  end

  def image_store_file
    return "public" << self.image_uri
  end

  def thumbnail_store_file
    return "public" << self.thumb_uri
  end

  def image_uri
    return  Map.geturi + "map_#{self.id}.jpg" if self.web == 0
    return "/images/web_map.jpg"
  end

  def thumb_uri
    return Map.geturi + "thumb_#{self.id}.jpg" if self.web == 0
    return "/images/web_map.jpg"
  end

  def save_image(file)
    f = File.new(self.image_store_file, "wb")
    f.write file.read
    f.close
    #f = File.new(self.image_store_file, "rb")
    gen_thumbnail(self.image_store_file)
    #f.close
  end

  def gen_thumbnail(file)
    ImageScience.with_image(file) do |img|
      img.thumbnail(200) do |thumb|
        thumb.save self.thumbnail_store_file
      end
    end
  end

  def destroy_image
    FileUtils.rm_rf self.image_store_file
    FileUtils.rm_rf self.thumbnail_store_file
  end

  def self.tree_xml(xml, map)
    self.find_all_children_xml(map, xml)
  end

  def self.find_all_children_xml(map, xml)
    backup = map
    xml.Map({:name => map.name,:web => map.web, :city => map.city,
             :img => map.image_uri, :thumb => map.thumb_uri, :parent => map.parent_id, :id => map.id, :isBranch => !map.children.empty?}) do
      unless map.children.empty? #纵向遍历
        map = map.children.first
        self.find_all_children_xml(map, xml)
      end
    end

    map = backup #回溯
    if map.right_sibling #横向遍历
      map = map.right_sibling
      self.find_all_children_xml(map, xml)
    end
  end

  def tree_data()
    list = []
    Map.find_all_children(self, list)
    return list
  end

  def self.find_all_children(map, list)
    backup = map
    list << map
    unless map.children.empty? #纵向遍历
      map = map.children.first
      self.find_all_children(map, list)
    end

    map = backup #回溯
    if map.right_sibling #横向遍历
      map = map.right_sibling
      self.find_all_children(map, list)
    end
  end

  def right_sibling
    index = index_of_siblings + 1
    return nil if siblings.empty? || self_and_siblings.size == index
    return self_and_siblings[index]
  end

  def index_of_siblings
    return 0 if self_and_siblings.empty?
    self_and_siblings.each_with_index do |g, index|
      return index if g.id == id
    end
  end

  def self.top_maps
    return Map.find_all_by_parent_id(0)
  end
end