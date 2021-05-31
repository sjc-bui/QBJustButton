Pod::Spec.new do |s|
  s.name             = 'QBJustButton'
  s.version          = '0.1.0'
  s.summary          = 'Smooth rounded button'

  s.description      = <<-DESC
TODO: Smooth rounded button.
                       DESC

  s.homepage         = 'https://github.com/sjc-bui/QBJustButton'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'sjc-bui' => 'bui@setjapan.co.jp' }
  s.source           = { :git => 'https://github.com/sjc-bui/QBJustButton.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'
  s.swift_version = '5.0'

  s.source_files = 'QBJustButton/Classes/**/*'

end
