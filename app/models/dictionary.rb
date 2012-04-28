class Dictionary
  require 'rexml/document'
  include REXML

  FILE = "./dictionary.xml"
  DOC = Document.new(File.new(FILE))
  XML = DOC.root
  @@dict = nil

  def self.get_dictionary()
    if !@@dict
      @@dict = Dictionary.new
    end
    return @@dict
  end

  def get_device(id)
    return get_category('Devices').elements["Device[@id='" + id + "']"]
  end

  def get_category(cate)
    return XML.elements[cate]
  end

  def get_device_inf(id)
    node = get_device(id)
    inf = {}
    node.elements.each do |el|
      inf[el.name] = el.text
    end
    return inf
  end

  def driver_add(xml)
    device = Document.new(xml).root
    devices = get_category('Devices')
    devices.elements << device
    write
  end

  def driver_update(id, field, value)
    device = get_device(id)
    device.elements[field].text = value
    write
  end

  def add(category, xml)
    cate = get_category(category)
    item = Document.new(xml).root
    cate.elements << item
    write
  end

  def update(category, id, value)
    cate = get_category(category)
    item = cate.elements['Item[@id="' + id  + '"]']
    item.attributes['name'] = value
    write
  end

  def write()
    File.open(FILE, "w") { |file| DOC.write( file, 2 ) }  
  end
end