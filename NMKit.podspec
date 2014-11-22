Pod::Spec.new do |s|
  s.name         = "NMKit"
  s.version      = "1.0.3"
  s.summary      = "Novilab Mobile Library"
  s.homepage     = "https://github.com/KoNEW/NMKit"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "KoNEW" => "konev.nmkit@gmail.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/KoNEW/NMKit.git", :tag => "1.0.3" }
  s.source_files = "Classes/**/*.{h,m}"
  s.public_header_files = "Classes/**/*.h"
  s.resources    = "Classes/Resources/*"
  s.frameworks   = "Foundation", "UIKit"
  s.requires_arc = true
end
