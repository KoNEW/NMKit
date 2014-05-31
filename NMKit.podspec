Pod::Spec.new do |s|
  s.name         = "NMKit"
  s.version      = "0.0.3"
  s.summary      = "Novilab Mobile Library"
  s.homepage     = "https://github.com/KoNEW/NMKit"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "KoNEW" => "konev.vn@gmail.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/KoNEW/NMKit.git", :tag => "0.0.3" }
  s.source_files = "Classes/*.{h,m}"
  s.public_header_files = "Classes/*.h"
  s.framework    = "Foundation"
  s.requires_arc = true
end
