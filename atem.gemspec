Gem::Specification.new do |s|
	s.name        = 'libatem'
	s.version     = '0.0.1'
	s.date        = '2017-07-02'
	s.summary     = "ATEM for Ruby"
	s.description = "A library that allows control of Blackmagic Design ATEM switchers through Ruby"
	s.authors     = ["Jamie Woods"]
	s.email       = 'gnitupmoc@insanityradiodotcom'
	s.files       = Dir.glob("{bin,lib}/**/*") + %w(README.md)
	s.homepage    = 'https://tech.insanityradio.com/'
	s.license     = 'MIT'
end
