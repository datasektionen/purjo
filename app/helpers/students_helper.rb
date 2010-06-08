module StudentsHelper

  # Byter ut sektiontexten mot en lite mer färggran version
  def color_section str
    repl = {
    'D' => { :background => '#e2007f', :color => 'white' },
    'DRIF' => { :background => 'black', :color => '#e2007f', :text => "D" },
    'F' => { :background => '#e44e0d', :color => 'white' },
    'CL' => { :background => 'red', :color => 'black' },
    'K' => { :background => 'yellow', :color => 'black' },
    'C' => { :background => 'yellow', :color => 'black' },
    'M' => { :background => '#b01212', :color => 'white' },
    'I' => { :background => 'brown', :color => 'white' },
    'A' => { :background => '#800080', :color => 'white' },
    'IT' => { :background => '#cc99ff', :color => 'white' },
    'E' => { :background => 'white', :color => 'black' },
    'S' => { :background => 'green', :color => 'white' }
    }

    if repl[str]
      s = repl[str][:text] ? repl[str][:text] : str
      '<span style="background: ' + repl[str][:background] + '; color: ' + repl[str][:color] + '" class="color_section">'+s+'</span>'
    else
      '<span style="padding: 2px 5px;">'+str+'</span>' if str
    end
  end
end

