require File.dirname(__FILE__) + '/../spec_helper'

describe Ior::LiquidFilters::MenuItem do
  before(:all) do
    Liquid::Template.register_tag('item', Ior::LiquidFilters::MenuItem)
    Liquid::Template.register_tag('menu', Ior::LiquidFilters::Menu)
  end
  
  it "should raise context error when used outside menu block" do
    "{% item 'name', 'url' %}".should render_liquid("Liquid error: Can't have a item outside a menu block")
  end
  
  it "should render url relative to one node above when inside a menu block without param" do
    expected_url = "../url"
    %Q({%menu%}{% item "name", "url" %}{%endmenu%}).should 
      render_liquid(%Q{<ul style="list-style-image: url(/images/icon_square.gif);">\n<li><a href="../url">name</a></li>\n</ul>})
  end
  
  it "should render url relative to parameter if given" do
    expected_url = "/foo/url"
    %Q({%menu "/foo"%}{% item "name", "url" %}{%endmenu%}).should
      render_liquid(%Q{"<ul style="list-style-image: url(/images/icon_square.gif);">\n<li><a href="#{expected_url}">name</a></li>\n</ul>"})
  end
end

class RenderLiquid
  include Liquid
  def initialize(expected, assigns)
    @expected = expected
    @assigns = assigns
  end

  def matches?(actual)
    @actual = actual
    # Satisfy expectation here. Return false or raise an error if it's not met.
    @result = Template.parse(actual).render(@assigns)
    render_liquid_template(actual, @assigns) == @expected 
  end

  def failure_message
    "expected #{@actual.inspect} to render_liquid #{@expected.inspect}, but it rendered as #{@result.inspect}"
  end

  def negative_failure_message
    "expected #{@actual.inspect} not to render_liquid #{@expected.inspect}, but it did"
  end
end

def render_liquid(expected, assigns = {})
  RenderLiquid.new(expected, assigns)
end


def render_liquid_template(template, assigns = {})
  Liquid::Template.parse(template).render(assigns)
end