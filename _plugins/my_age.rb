module Jekyll
  class MyAgeTag < Liquid::Tag

    def render(context)
      (Date.today.strftime("%Y%m%d").to_i - 19870908).to_s.reverse.slice(4,3).reverse
    end

  end
end

Liquid::Template.register_tag('my_age', Jekyll::MyAgeTag)
