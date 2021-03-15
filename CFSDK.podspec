#
# Be sure to run `pod lib lint CFSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|

s.name			= "CFSDK"
s.version		= "3.0.0-beta"
s.summary		= "Cocoapod implementation off Cashfree's Payment SDK"

s.description		= <<-DESC
	Cashfree is a next generation payment gateway that helps 50,000+ Indian and global businesses collect and disburse payments via 100+ payment methods including Visa, MasterCard, Rupay, UPI, IMPS, NEFT, Paytm & other wallets, Pay Later and various EMI options. Cashfree is backed by Silicon Valley investor Y Combinator and was incubated by Paypal.
		  DESC
s.homepage		= "https://github.com/cashfree/ios-CFWebSDK.git"
s.license		= 'MIT'
s.author			= { "Cashfree" => "developer@cashfree.com" }
s.source			= { :git => "https://github.com/cashfree/ios-CFWebSDK.git", :tag => s.version }

s.platform		= :ios, "10.0"
s.vendored_frameworks	= "CFSDK.xcframework"
s.swift_version		= "5.0"

end