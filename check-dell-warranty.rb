#!/usr/bin/env ruby
# title:  check-dell-warranty.rb
# descr:  gets expiration dates for one or more service tags
# author: andrew o'neill
# date:   2016

require 'net/http'
require 'json'
require 'date'

# enter your dell api key here
@apikey = '849e027f476027a394edd656eaef4842'

# look up the service tag via dell's api
def get_expiration(svctag)
  exp_date = nil
  uri = URI("https://api.dell.com/support/v2/assetinfo/warranty/tags.json?svctags=#{svctag}&apikey=#{@apikey}")
  res = Net::HTTP.get_response(uri)
  
  if res.code != '200'
    puts "Call to Dell API for #{svctag} failed: #{res.message}"
    exit 1
  end
  
  json = JSON.parse(res.body)
  top_level = json['GetAssetWarrantyResponse']['GetAssetWarrantyResult']['Response']['DellAsset']
  description = top_level['MachineDescription']
  warranties = top_level['Warranties']['Warranty']
  
  warranties.each do |w|
    if w['EntitlementType'].downcase == 'extended' && w['ServiceLevelCode'].downcase == 'nd'
      exp_date = Date.parse(w['EndDate']).strftime("%m/%d/%Y")
      break
    # recently purchased hardware doesn't have an extended entitlement just yet  
    elsif w['EntitlementType'].downcase == 'initial' && w['ServiceLevelCode'].downcase == 'nd'
      exp_date = Date.parse(w['EndDate']).strftime("%m/%d/%Y")
      break
    else
      next
    end
  end

  if ! exp_date.nil?
    return "#{exp_date} -- #{description}"
  else
    return "Unable to determine expiration date"
  end
end

# make sure that something is being passed in
if ARGV.empty?
  puts "usage: $ ./check-dell-warranty.rb <service tag 1> [service tag N] ..."
  exit 1
end

# run through each service tag passed in
ARGV.each do |svctag|
  puts "#{svctag}: #{get_expiration(svctag)}"
end
