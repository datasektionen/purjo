if Object.const_defined?(:Refraction)
  Refraction.configure do |req|
    if req.path =~ %r{^.*/nyheter/rss.php$} || req.path =~ %r{^/nyheter.rss}
      req.permanent!("/rss")
    elsif (req.path =~ %r{^/nyheter$} && req.method == "GET") || req.path =~ %r{^/nyheter?archive=} 
      req.permanent!("/")
    end
    
    # RewriteCond %{REQUEST_URI} ^/sektionen/sok/teknolog.php$
    # RewriteCond %{QUERY_STRING} user=([-_A-Za-z0-9]+)
    # RewriteRule ^.*$ /students/%1? [R=301,L]
    if req.path =~ %r{sektionen/sok/teknolog.php} && req.query =~ %r{user=([-_A-Za-z0-9]+)}
      req.permanent!("/students/#{$1}")
    end
    
    if req.path =~ %r{/sektionen/sok}
      req.permanent!("/sok?" + req.query)
    end
    
    if req.path =~ %r{^/mottagningen/janifattar/?$}
      req.permanent!("http://www.d.kth.se/ston/apps/new")
    end
    
    if req.path =~ %r{^/mottagningen(/(.*))?$}
      req.found!("/sektionen/mottagningen/#{$2}")
    end

    if req.path =~ %r{^/dkm(/(.*))?$}
      req.found!("/sektionen/dkm/#{$2}")
    end
    
    if req.path =~ %r{/sektionen/namnder/naringsliv/ddagen/}
      req.permanent!("/naringsliv/d-dagen")
    end
    
    case req.path
    when %r{^/ovve(/(.*))?$}
      # RewriteRule ^/ovve(/(.*))?$ /sektionen/namnder/prylmanglaren/ovve/$2 [R,L]
      req.found!("/sektionen/namnder/prylmanglaren/ovve/#{$2}")
    when %r{^/ddagen(/(.*))?$}
      # RewriteRule ^/ddagen(/(.*))?$ /sektionen/namnder/naringsliv/ddagen/$2 [R,L]
      req.found!("/sektionen/namnder/naringsliv/ddagen/#{$2}")
    #when %r{^/sektionen/namnder/mottagningen/(janifattar|ansokan)(/(.*))?$}
    #  # RewriteRule ^/sektionen/namnder/mottagningen/(janifattar|ansokan)(/(.*))?$ /ston/apps/new [R,L]
    #  req.found!("/ston/apps/new")
    when %r{^/sektionen/datasektionens_seniorverksamhet(/(.*))?$}
      # RewriteRule ^/sektionen/datasektionens_seniorverksamhet(/(.*))?$ /sektionen/alumni/$2 [R,L]
      req.found!("/sektionen/alumni/#{$2}")
    when %r{^/gor_skillnad/?}
      req.found!("/sektionen/namnder/ior/gor_skillnad")
    #when %r{^/n[0|o]llegasque(/(.*))?$}
    #  # RewriteRule ^/n[0|o]llegasque(/(.*))?$ https://www.d.kth.se/ston/events/15/external_booking [R,L]
    #  req.found!("https://www.d.kth.se/ston/events/15/external_booking")
    end
  end
end
