Pod::Spec.new do |s|
  s.name         = "RNEegMuseLib"
  s.version      = "6.0.3"
  s.summary      = "RNEegMuseLib"
  s.description  = <<-DESC
                  RNEegMuseLib
                   DESC
  s.homepage     = ""
  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  s.author             = { "author" => "author@domain.cn" }
  s.platform     = :ios, "10.3"
  s.source       = { :git => "https://github.com/author/RNEegMuseLib.git", :tag => "master" }
  s.source_files  = "RNEegMuseLib/**/*.{h,m}"
  s.requires_arc = true


  s.dependency "React"
end
