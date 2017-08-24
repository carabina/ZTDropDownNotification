Pod::Spec.new do |s|
  s.name         = "ZTDropDownNotification"
  s.version      = "1.0.0"
  s.summary      = "An iOS drop-down notification."
  s.description  = <<-DESC
                    ZTDropDownNotification is a notification class that displays a drop-down notification
                    from top edge of key window and dismisses it after a duration. The default layouts can
                    display message only or message with icon. It also supports custom layout and displays
                    custom view directly. The notification is inspired by Mobile QQ, aiming to provide a
                    handy way to show notifications.
                   DESC
  s.homepage     = "https://github.com/tatowilson/ZTDropDownNotification"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author             = { "Zhang Tao" => "me@zhangtom.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/tatowilson/ZTDropDownNotification.git", :tag => "#{s.version}" }
  s.source_files  = "*.{h,m}"
end