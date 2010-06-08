require 'date'

# CalendarHelper allows you to draw a databound calendar with fine-grained CSS formatting
module Ior
  module CalendarHelper
  
    VERSION = '0.3'
    
    MONTH_NAMES = [nil] + %w{Januari Februari Mars April Maj Juni Juli Augusti September Oktober November December}
    DAY_NAMES = %w{ Måndag Tisdag Onsdag Torsdag Fredag Lördag Söndag }
  
    # Returns an HTML calendar. In its simplest form, this method generates a plain
    # calendar (which can then be customized using CSS).
    # However, this may be customized in a variety of ways -- changing the default CSS
    # classes, generating the individual day entries yourself, and so on.
    # 
    # The following are optional, available for customizing the default behaviour:
    #   :month                => Time.now.month # The month to show the calendar for. Defaults to current month.
    #   :year                 => Time.now.year  # The year to show the calendar for. Defaults to current year.
    #   :table_class          => "calendar"     # The class for the <table> tag.
    #   :month_name_class     => "monthName"    # The class for the name of the month, at the top of the table.
    #   :other_month_class    => "otherMonth"   # Not implemented yet.
    #   :day_name_class       => "dayName"      # The class is for the names of the weekdays, at the top.
    #   :day_class            => "day"          # The class for the individual day number cells.
    #                                             This may or may not be used if you specify a block (see below).
    #   :abbrev               => (0..2)         # This option specifies how the day names should be abbreviated.
    #                                             Use (0..2) for the first three letters, (0..0) for the first, and
    #                                             (0..-1) for the entire name.
    #   :first_day_of_week    => 0              # Renders calendar starting on Sunday. Use 1 for Monday, and so on.
    #   :accessible           => true           # Turns on accessibility mode. This suffixes dates within the
    #                                           # calendar that are outside the range defined in the <caption> with 
    #                                           # <span class="hidden"> MonthName</span>
    #                                           # Defaults to false.
    #                                           # You'll need to define an appropriate style in order to make this disappear. 
    #                                           # Choose your own method of hiding content appropriately.
    #
    #   :show_today           => false          # Highlights today on the calendar using the CSS class 'today'. 
    #                                           # Defaults to true.
    #   :month_name_text      => nil            # Displayed center in header row. Defaults to current month name from Date::MONTHNAMES hash.
    #   :previous_month_text  => nil            # Displayed left of the month name if set
    #   :next_month_text      => nil            # Displayed right of the month name if set
    #
    # For more customization, you can pass a code block to this method, that will get one argument, a Date object,
    # and return a values for the individual table cells. The block can return an array, [cell_text, cell_attrs],
    # cell_text being the text that is displayed and cell_attrs a hash containing the attributes for the <td> tag
    # (this can be used to change the <td>'s class for customization with CSS).
    # This block can also return the cell_text only, in which case the <td>'s class defaults to the value given in
    # +:day_class+. If the block returns nil, the default options are used.
    # 
    # Example usage:
    #   calendar                                    # This generates the simplest possible calendar with the curent month and year.
    #   calendar({:year => 2005, :month => 6})      # This generates a calendar for June 2005.
    #   calendar({:table_class => "calendar_helper"}) # This generates a calendar, as
    #                                                                             # before, but the <table>'s class
    #                                                                             # is set to "calendar_helper".
    #   calendar(:abbrev => (0..-1))                # This generates a simple calendar but shows the
    #                                                            # entire day name ("Sunday", "Monday", etc.) instead
    #                                                            # of only the first three letters.
    #   calendar do |d|                             # This generates a simple calendar, but gives special days
    #     if listOfSpecialDays.include?(d)          # (days that are in the array listOfSpecialDays) one CSS class,
    #       [d.mday, {:class => "specialDay"}]      # "specialDay", and gives the rest of the days another CSS class,
    #     else                                      # "normalDay". You can also use this highlight today differently
    #       [d.mday, {:class => "normalDay"}]       # from the rest of the days, etc.
    #     end
    #   end
    #
    # An additional 'weekendDay' class is applied to weekend days. 
    #
    # For consistency with the themes provided in the calendar_styles generator, use "specialDay" as the CSS class for marked days.
    # 
    def calendar(calendar_items, options = {}, &block)
      block ||= Proc.new {|d| nil}
  
      defaults = {
        :year                => Time.now.year,
        :month               => Time.now.month,
        :table_class         => 'calendar',
        :month_name_class    => 'monthName',
        :other_month_class   => 'otherMonth',
        :day_name_class      => 'dayName',
        :day_class           => 'day',
        :abbrev              => (0..2),
        :first_day_of_week   => 0,
        :accessible          => false,
        :show_today          => true,
        :month_name_text     => Date::MONTHNAMES[Time.now.month],
        :previous_month_text => nil,
        :next_month_text     => nil,
        :week_class          => 'week'
      }
      options = defaults.merge options
  
      first = Date.civil(options[:year], options[:month], 1)
      last = Date.civil(options[:year], options[:month], -1)
  
      first_weekday = first_day_of_week(options[:first_day_of_week])
      last_weekday = last_day_of_week(options[:first_day_of_week])
      
      if DAY_NAMES.nil?
        day_names = Date::DAYNAMES.dup
        first_weekday.times do
          day_names.push(day_names.shift)
        end
      else
        day_names = DAY_NAMES
      end
      

      a_tag(:table, :class => options[:table_class], :border => 0, :cellspacing => 0, :cellpadding => 0) do |cal|
        cal << a_tag(:thead) do |head|
          head << a_tag(:tr, :class => options[:day_name_class]) do |days|
            days << a_tag(:th, 'V.', :class => options[:week_class])
            
            day_names.each do |d|
              unless d[options[:abbrev]].eql? d
                days << a_tag(:th, "<abbr title='#{d}'>#{d[options[:abbrev]]}</abbr>", :scope => 'col')
              else
                days << a_tag(:th, d[options[:abbrev]], :scope => 'col')
              end
            end
          end
        end
        cal << a_tag(:tbody) do |body|
          body << "<tr>"
          body << a_tag(:td, :class => options[:week_class]) {|week| week << first.cweek.to_s }
          beginning_of_week(first, first_weekday).upto(first - 1) do |d|
            day_classes = options[:other_month_class]
            day_classes += " weekendDay" if weekend?(d)
            day = d.day
            day << a_tag(:span, Date::MONTHNAMES[d.mon], :class => "hidden") if options[:accessible]
            body << a_tag(:td, day, :class => day_classes)
          end unless first.wday == first_weekday
          first.upto(last) do |cur|
            #cell_content = block.call(cur)
            
            cell_text = a_tag(:p, cur.mday, :class => 'daynumber')
            cell_text << cell_content(calendar_items, cur)
            
            #cell_text = a_tag(:p, a_tag(:a, cur.mday, :href => '/'), :class => 'daynumber') + cell_text
            
            cell_attrs ||= {:class => options[:day_class]}
            cell_attrs[:class] += " weekendDay" if weekend?(cur) 
            cell_attrs[:class] += " today" if (cur == Date.today) and options[:show_today]
            body << a_tag(:td, cell_text, cell_attrs)
            
            if cur.wday == last_weekday
              body << "</tr>"
              body << "<tr>"
              body << a_tag(:td, :class => 'week') {|week| week << (cur.cweek + 1).to_s }
            end
          end
          (last + 1).upto(beginning_of_week(last + 7, first_weekday) - 1) do |d|
            day_classes = options[:other_month_class]
            day_classes += " weekendDay" if weekend?(d)
            day = d.day
            day << a_tag(:span, Date::MONTHNAMES[d.mon], :class => "hidden") if options[:accessible]
            body << a_tag(:td , day, :class => day_classes)
          end unless last.wday == last_weekday
          body << '</tr>'
        end
      end
    end
    
    private
    
    def cell_content(posts, day)
      # debugger if day.day == 5 && day.month == 8
      posts_this_day = posts.select { |posts| 
        (posts.starts_at.beginning_of_day..posts.ends_at.end_of_day) === day.to_datetime
      }
      posts_this_day.map { |post| link_to(post.name, post_path(post)) }.join("\n")
    end
    
    def first_day_of_week(day)
      day
    end
    
    def last_day_of_week(day)
      if day > 0
        day - 1
      else
        6
      end
    end
    
    def days_between(first, second)
      if first > second
        second + (7 - first)
      else
        second - first
      end
    end
    
    def beginning_of_week(date, start = 1)
      days_to_beg = days_between(start, date.wday)
      date - days_to_beg
    end
    
    def weekend?(date)
      [0, 6].include?(date.wday)
    end
    
    # like content_tag but if block given with an argument, argument can used as 
    # as accumulator for html inside tag when called from a helper module.
    # 
    # Example:
    #   a_tag(:div) do |content|
    #     content << "nicer"
    #     content << "syntax!"
    #   end
    #
    # Returns:
    #   <div>nicer syntax!</div>   
    def a_tag(name, content_or_options_with_block = nil, options = nil, escape = true, &block)
      if block_given? && block.arity == 1
        options = content_or_options_with_block if content_or_options_with_block.is_a?(Hash)
        content = returning(String.new) do |content|
          block.call(content)
        end
        content_tag_string(name, content, options, escape)
      else
        content_tag(name, content_or_options_with_block, options, escape, &block)
      end
    end
  end
end
  
